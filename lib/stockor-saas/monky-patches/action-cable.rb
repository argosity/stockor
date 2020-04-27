module StockorSaas::MonkeyPatches

    module MultTenantCableHandler
        module ClassMethods
            def handle_request(request)
                tenant = StockorSaas::Elevator.get_tenant_name_for_host(request.host)
                Apartment::Tenant.switch(tenant) do
                    Lanes.logger.debug "New Connection Request; Tenant: #{tenant}"
                    super
                end
            end
        end
        def self.prepended(base)
            class << base
                prepend ClassMethods
            end
        end

        Lanes::API::Cable.prepend self
    end



    module MultTenantCableConnection
        def connect
            Apartment::Tenant.switch(tenant) do
                Lanes.logger.debug "Conn tenant: #{tenant}"
                super
            end
        end
        # new method that's used by PubSub to prefix
        def tenant
            @tenant ||= StockorSaas::Elevator.get_tenant_name_for_host(env['HTTP_HOST'])
        end

        Lanes::API::Cable::Connection.prepend self
    end


    module MultTenantPubSub
        def channel_prefix
            "ps.#{connection.tenant}:"
        end
        module ClassMethods
            def channel_prefix
                "ps.#{Apartment::Tenant.current}:"
            end
        end

        def self.prepended(base)
            class << base
                prepend ClassMethods
            end
        end
        Lanes::API::PubSub.prepend self
    end
end
