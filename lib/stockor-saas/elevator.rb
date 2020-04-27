require 'apartment/elevators/generic'
module StockorSaas

    class Elevator < ::Apartment::Elevators::Generic
        FOUND = {}

        def self.get_tenant_name_for_host(host)
            index = host.index('.')
            host = index ? host[0...index] : host
            unless FOUND.has_key? host
                FOUND[host] = StockorSaas::Tenant.where(domain: host).exists?
            end
            FOUND[host] ? host :
                Lanes.env.production? ? 'public' : (ENV['DOMAIN'] || 'argosity')
        end

        # @return {String} - The tenant to switch to
        def parse_tenant_name(request)
            Elevator.get_tenant_name_for_host(request.host)
        end
    end

end
