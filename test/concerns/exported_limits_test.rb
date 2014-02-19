require_relative '../test_helper'


class ExportedLimitsTest < Skr::TestCase

    class LimitsTestingModel

        include Skr::Concerns::ExportScope
        include Skr::Concerns::ExportMethods

        def self.scope(name, query)# act like ActiveRecord model
        end

        def secret_method( name, query )
        end

        def test_method( name, query )
        end

        export_methods :test_method, limit: lambda{ | user, type, name |
            user == 'anon'
        }

        export_scope :admin_data, lambda{ | param |
            param
        }, limit: :only_admins

        export_methods :secret_method, limit: :only_admins


        def self.only_admins( user, type, name )
            return user == 'admin'
        end

    end

    def test_limits
        assert LimitsTestingModel.has_exported_method?( 'test_method', 'anon' ), "anyone can retrieve no_limit data"

        assert LimitsTestingModel.has_exported_scope?( 'admin_data', 'admin' ), "Admins can retrieve admin data"
        refute LimitsTestingModel.has_exported_scope?( 'admin_data', 'non-admin' ), "Non-Admin cannot retrieve admin data"

        assert LimitsTestingModel.has_exported_method?( 'secret_method', 'admin' ), "Public can retrieve public data"
        refute LimitsTestingModel.has_exported_method?( 'secret_method', 'unk' ), "User must be admin to retrieve public data"
    end

end
