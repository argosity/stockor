module Skr::Core

    @logger = if defined?(::Rails)
                  Rails.logger
              else
                  Logger.new(STDERR)
              end
    class << self
        def logger
            @logger
        end

        def logger=( logger )
            @logger = logger
        end

        def silence_logs( &block )
            old_logger = Skr::Core.logger
            begin
                Skr::Core.logger=Logger.new( StringIO.new )
                yield
            ensure
                Skr::Core.logger=old_logger
            end
        end
    end
end
