require 'lanes/api/formatted_reply'

module Skr
    module Handlers
        class SequentialIds

            attr_reader :model, :user, :params, :data
            include Lanes::API::FormattedReply

            TYPES = %w{ Invoice SalesOrder GlManualEntry InventoryAdjustment Payment PickTicket Voucher }

            def initialize(model, authentication, params, data)
                @data = data
            end

            def perform_retrieval
                ids = {}
                Skr::SequentialId.pluck(:name, :current_value).map do |name, count|
                    ids[name.demodulize] = count
                end
                list = TYPES.map do | t |
                    {id: t, name: t.titleize, count: ids[t] || 0}
                end
                Skr::BankAccount.find_each do |ba|
                    id = Payment::SEQUENTIAL_ID_PREFIX + ba.id.to_s
                    list.push({id: id, name: "#{ba.name} Check", count: ids[id] || 0})
                end
                std_api_reply(:retrieve, {id: 'all', ids: list}, success: true)
            end

            def perform_update
                data['ids'].each do | si |
                    Lanes.logger.warn "#{si['id']}"
                    id = if 0 == si['id'].index(Payment::SEQUENTIAL_ID_PREFIX)
                             si['id']
                         else
                             "Skr::#{si['id']}"
                         end
                    Skr::SequentialId.set_next(id, si['count'])
                end
                std_api_reply(:create, {ids: data['ids']}, success: true )
            end

        end
    end
end
