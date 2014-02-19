module MiniTest
    module Assertions

        def assert_logs_matching( regex, failure_message=nil, &block )
            old_logger = Skr::Core.logger
            begin
                output = ""
                Skr::Core.logger=Logger.new( StringIO.new(output) )
                yield
                assert_match( regex, output, failure_message )
            ensure
                Skr::Core.logger=old_logger
            end
        end


        def assert_saves( model )
            assert model.save, "#{model.class} failed to save: #{model.errors.full_messages.join(',')}"
        end


    end
end
