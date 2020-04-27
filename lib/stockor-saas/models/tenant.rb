module StockorSaas

    class Tenant < Model

        validates :domain, uniqueness: true
        self.table_name = 'public.tenants'

        before_validation(:on=>:create) do
            unless name.blank?
                self.domain ||= Lanes::Strings.code_identifier(
                    name, length:10, padding: ''
                ).downcase
            end
        end

        after_create  { Apartment::Tenant.create(domain)         }
        after_commit  { StockorSaas::DB.seed_tenant(self.domain) }
        after_destroy { Apartment::Tenant.drop(self.domain)      }

        def self.current
            self.find_by(domain: Apartment::Tenant.current)
        end

        def exposed_data
            as_json(except: [:id, :created_at, :updated_at])
        end
    end

end
