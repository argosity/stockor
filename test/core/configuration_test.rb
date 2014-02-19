require_relative '../test_helper'

describe Skr::Core::Configuration do

    def test_default_values
        conf = Skr::Core::Configuration.new
        Skr::Core.silence_logs do
            assert_equal '01', conf.default_branch_code
            assert_equal '01', Skr::Core.config.default_branch_code
        end
    end

    def test_changing_values_are_logged
        begin
            assert_logs_matching( /default_branch_code changed from 01 to 02/ ) do
                Skr::Core.config.default_branch_code='02'
            end
        ensure
            Skr::Core.silence_logs {   Skr::Core.config.default_branch_code='01' }
        end
    end


end
