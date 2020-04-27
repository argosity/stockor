require_relative "../stockor-saas"

require "lanes/workspace/extension"
require 'lanes/access/extension'
require 'skr/extension'


module StockorSaas

    class Extension < Lanes::Extensions::Definition

        identifier "stockor-saas"


        root_path Pathname.new(__FILE__).dirname.join("..","..").expand_path

        # If a data structure that can be represented as JSON
        # is returned from this method, it will be passed to
        # the setBootstrapData method in client/stockor-saas/Extension.coffee
        # when the app boots
        def client_bootstrap_data(view)
            tenant = Tenant.current
            { tenant: tenant ? tenant.exposed_data : {} }
        end

        def title
            Apartment::Tenant.current.titleize
        end

    end

end
