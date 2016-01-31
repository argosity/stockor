require_relative 'base'

module Skr::Jobs::FreshBooks

    class Import < Base
        def to_name(r)
            [r['first_name'], r['last_name']].compact.join(' ')
        end

        def customer_for_fb_id(id)
            Skr::Customer.where("options ->>'freshbooks_id' = ?", id).first
        end

        def is_ignored?(type, id)
            @ignored_ids[type] && @ignored_ids[type].include?(id)
        end

        def get_user(staff_id)
            if @user_mappings[staff_id]
                Lanes::User.find(@user_mappings[staff_id])
            else
                Lanes::User.where("options ->>'freshbooks_id' = ?", staff_id).first
            end
        end

        def process_client(r)
            return nil if is_ignored?('clients',  r['client_id'])
            Skr::Customer.create(
                name: r['organization'], options: { freshbooks_id: r['client_id'] },
                notes: r['notes'], credit_limit: r['credit'],
                billing_address_attributes: {
                    name: to_name(r),
                    email: r['email'], phone: r['work_phone'] || r['mobile'] || r['home_phone'],
                    line1: r['p_street1'], line2: r['p_street2'], city: r['p_city'],
                    state: r['p_state'], postal_code: r['p_code']
                },
                shipping_address_attributes: {
                    name: to_name(r),
                    email: r['email'], phone: r['mobile'] || r['work_phone'] || r['home_phone'],
                    line1: r['s_street1'], line2: r['s_street2'], city: r['s_city'],
                    state: r['s_state'], postal_code: r['s_code']
                }
            )
        end

        def process_staff(r)
            return nil if is_ignored?('staff',  r['staff_id']) or @user_mappings[r['staff_id']]
            Lanes::User.create(
                login: r['username'],
                name: to_name(r),
                password: 'password',
                email: r['email'],
                options: { freshbooks_id: r['staff_id'] },
                role_names: ['workforce']
            )
        end

        def process_project(r)
            return nil if is_ignored?('projects',  r['project_id'])
            Skr::CustomerProject.create(
                name: r['name'], description: r['description'],
                sku: Skr::Sku.find_by(code: 'LABOR'),
                customer: customer_for_fb_id(r['client_id']),
                options: { freshbooks_id: r['project_id'] },
                rates: {"hourly": r['rate']},
            )
        end

        def process_time_entry(r)
            return nil if is_ignored?('time_entries',  r['time_entry_id'])
            Skr::TimeEntry.create(
                is_invoiced: r['billed'] == '1',
                options: { freshbooks_id: r['time_entry_id'] },
                customer_project: Skr::CustomerProject.where("options ->>'freshbooks_id' = ?", r['project_id']).first,
                description: r['notes'],
                start_at: DateTime.parse(r['date']) + 8.hours,
                end_at:   DateTime.parse(r['date']) + 8.hours + r['hours'].to_i.hours,
                lanes_user: get_user(r['staff_id'])
            )
        end

        def process_invoice(r)
            return nil if is_ignored?('invoices',  r['invoice_id'])
            inv = Skr::Invoice.create(
                visible_id: r['number'].sub(/^0+/,''),
                options: { freshbooks_id: r['invoice_id'] },
                customer: customer_for_fb_id(r['client_id']),
                location: Skr::Location.default,
                po_num: r['po_number'], invoice_date: r['date'], notes: r['notes'],
                terms: Skr::PaymentTerm.find_by(days: r['terms'].to_s[/\d+/, 0] || 30),
                billing_address_attributes: {
                    name: to_name(r),
                    email: r['email'], phone: r['mobile'] || r['work_phone'] || r['home_phone'],
                    line1: r['p_street1'], line2: r['p_street2'], city: r['p_city'],
                    state: r['p_state'], postal_code: r['p_code']
                },
                lines_attributes: Array.wrap(r['lines']['line']).map { | l |
                    is_time = 'Time' == l['type']
                    if l['name'] or l['description'] # blank name == blank line
                        sku = Skr::Sku.find_by(code: is_time ? 'LABOR' : 'MISC')
                        invl = {
                            sku_loc: sku.sku_locs.default,
                            price: l['unit_cost'],
                            description: l['description'],
                            qty: l['quantity']
                        }
                        if l.has_key?('time_entries')
                            invl['time_entry'] =
                                Skr::TimeEntry.find_by("options ->>'freshbooks_id' = ?",
                                                       l['time_entries']['time_entry']['time_entry_id'])
                        end
                        invl
                    end
                }.compact
            )
            if r['paid'].to_f > 0
                inv.update_attributes(amount_paid: r['paid'])
            end
            inv
        end

        def perform(data)
            @ignored_ids = data['ignored_ids'] || {}
            @user_mappings = data['user_mappings'] || {}
            process_each_type(data['domain'], data['api_key']) do | output, index |
                save_progress(output, (index+1).to_f / STEPS.length)
            end
            self
        end

        def self.from_request(req)
            Lanes::Job.api_status_message self.perform_later(req)
        end

    end

end
