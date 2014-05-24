module Workspace
  module ApplicationHelper
      def skr_asset_paths_for( *assets )
          assets.each_with_object(Hash.new) do | asset, map |
              map[asset] = asset_path("skr/workspace/#{asset}")
          end
      end
  end
end
