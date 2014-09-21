# -*- coding: utf-8 -*-

module Skr::Core

    class << self
        def logger
            @logger ||= (
              if defined?(::Rails)
                  Rails.logger
              else
                  Logger.new(STDERR)
              end
            )
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

        def logger_debug( output )
            logger.debug '⚡ '*40
            logger.debug '⚡ ' + output
            logger.debug '⚡ '*40
        end
    end
end
