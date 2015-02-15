require 'lanes/access/extension'

module Skr

    class Extension < Lanes::Extensions::Definition

        identifier "skr"
        self.uses_pub_sub = true
        root_path Pathname.new(__FILE__).dirname.join("..","..").expand_path
        components "record-finder", "select-field"


    end

end
