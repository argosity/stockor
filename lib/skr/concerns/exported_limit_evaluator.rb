module Skr::Concerns

    module ExportedLimitEvaluator

        def evaluate_export_limit( user, type, name, limit )
            if limit.nil?
                true
            elsif limit.is_a?(Symbol)
                self.send( limit, user, type, name )
            else
                limit.call( user, type, name )
            end
        end

    end

end
