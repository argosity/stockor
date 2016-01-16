module Skr
    module Print
        class Template

            class Definition
                def initialize(path)
                    @path = path
                end
                def name
                    @path.basename.to_s
                end
                def choices
                    Pathname.glob(@path.join('*.tex')).map{|pn| pn.basename('.tex').to_s}
                end
                def model
                    "skr/#{name}".classify.constantize
                end
                def path_for_record(record)
                    return nil unless record.form
                    path = @path.join( record.form + '.tex' )
                    path.exist? ? path : @path.join( 'default.tex' )
                end
            end

            def self.get(type)
                Definition.new( Skr::Print::ROOT.join('types', type ) )
            end

            def self.definitions
                Pathname.glob(Skr::Print::ROOT.join('types','*')).select { | type |
                    type.directory?
                }.map { | type |
                    Definition.new( type )
                }
            end

            def self.as_json
                json={}
                definitions.each do | definition |
                    json[definition.name] = definition.choices
                end
                json
            end
        end
    end
end
