require 'lanes/access/extension'

module Skr

    class Extension < Lanes::Extensions::Definition

        identifier "skr"
        self.uses_pub_sub = true
        root_path Pathname.new(__FILE__).dirname.join("..","..").expand_path
        components "record-finder", "select-field"

        def on_boot
            Lanes::API::Root.before do
                Thread.current[:demo_user_info] = {
                  name: session[:name],
                  email: session[:email]
                }
            end
        end

    end

end
