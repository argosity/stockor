require 'apartment'
require_relative './monky-patches/action-cable'

class Lanes::SystemSettings

    ExtensionSettings.class_eval do
        STORAGES = {}

        alias_method :skr_saas_apply!, :apply!
        def apply!
            skr_saas_apply!()
            require_relative './shrine_file_system'
            root_path = ::Lanes::Extensions.controlling.root_path

            Lanes::Concerns::AssetUploader.storages = {
                cache: ::StockorSaas::ShrineFileSystem.new(root_path,
                                                           prefix: "tmp/cache"),
                store: ::StockorSaas::ShrineFileSystem.new(root_path,
                                                           prefix: "public/files")
            }
        end
    end

    ::Skr::Configuration.config_option(:domain_name, lambda {
                                           Apartment::Tenant.current + '.stockor.com'
                                       })

    self.instance_eval do
        CACHE = Hash.new {|h, tenant|
            h[tenant] =
                Lanes::SystemSettings.find_or_create_by(id: Lanes.config.configuration_id)
        }

        def config
            CACHE[Apartment::Tenant.current]
        end

        def clear_cache!(tenant)
            Lanes.logger.debug "Clearing cache for #{tenant}"
            CACHE.delete(tenant)
        end
    end

    def notify_updated
        Lanes.redis_connection.publish('lanes-system-configuration-update',
                                       Apartment::Tenant.current)
    end

end

require 'lanes/job'

module StockorSaas

    module MultiTenantActiveJob
        extend ActiveSupport::Concern

        class_methods do
            def execute(job_data)
                Apartment::Tenant.switch(job_data['tenant']) do
                    Lanes.logger_debug "TENANT: #{job_data['tenant']}"
                    super
                end
            end
        end

        def serialize
            Lanes.logger.info "TENANT: #{Apartment::Tenant.current}"
            super.merge('tenant' => Apartment::Tenant.current)
        end
    end

end

require 'resque'
Resque.after_fork do |job|
    ::Lanes::DB.establish_connection
end

require_relative '../../config/apartment'
require 'lanes/job'

module ::ActiveJob
    class Base
        include StockorSaas::MultiTenantActiveJob
    end
end



module Lanes::API

    def self.set_root_view( view )

        ::Lanes::API::Root.get Lanes.config.mounted_at + '?*' do
            if Apartment::Tenant.current == 'public' && Lanes.env.production?
                redirect 'https://stockor.com/', 302
            elsif request.accept? 'text/html'
                erb :lanes_root_view
            else
                pass
            end
        end

    end

end
