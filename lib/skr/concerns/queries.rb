module Skr
    module Concerns

        # A collection of handly utility methods to generate queries
        module Queries

            extend ActiveSupport::Concern

            module ClassMethods

                def compose_query_using_detail_view( view: view, join_to: join_to )
                    view = Skr::Core.config.table_prefix + view.to_s
                    joins("join #{view} as details on details.#{join_to} = #{table_name}.#{primary_key}")
                    .select("#{table_name}.*, details.*")
                end

            end
        end
    end
end
