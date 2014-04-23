module Skr::Concerns


    # Custom implentation of has_many and belongs_to
    #
    module AssociationExtensions

        extend ActiveSupport::Concern

        module ClassMethods

            def has_one(name, scope = nil, options = {})
                opts = extract_private_options( scope, options )
                associations = super
                handle_private_options( name, opts ) unless opts.empty?
                associations
            end

            def belongs_to(name, scope = nil, options = {} )
                opts = extract_private_options( scope, options )
                associations = super
                handle_private_options( name, opts ) unless opts.empty?
                associations
            end

            def has_many(name, scope=nil,options={}, &extension )
                opts = extract_private_options( scope, options )
                associations = super
                handle_private_options( name, opts ) unless opts.empty?
                associations
            end

            private

            def handle_private_options( name, opts )
                association = reflect_on_association( name.to_sym )
                setup_listeners( association, opts[:listen] ) if opts[:listen]
                setup_association_export( association, opts[:export] ) if opts[:export]
            end

            def extract_private_options( scope, options )
                if scope.is_a?(Hash)
                    scope.extract!( :export, :listen )
                else
                    options.extract!( :export, :listen )
                end
            end

            # This gets complex; We
            #   First setup proc's for each listener,
            #   then attempt to load the associations's class
            #   If that succeds, we're done, otherwise we add it
            #   to PubSub's pending queue
            def setup_listeners( association, listeners )
                targets = {}
                if listeners.any? && association.options[:inverse_of].nil?
                    raise RuntimeError.new "Setting listener on #{name}##{association.name} " +
                        "but the association does not have " +
                        "an inverse_of specified."
                end
                listeners.each do | name, target |
                    targets[ name ] = Proc.new{ | record, *args |
                        record = record.send( association.inverse_of.name )
                        record.send( target, *( [record] + args ) ) if record
                    }
                end
                begin
                    klass = association.klass # This will throw if the class hasn't been loaded yet
                    targets.each{ | name, proc | klass._add_event_listener( name, proc ) }
                rescue NameError
                    pending = PendingEventListeners.all[association.class_name]
                    targets.each do | name, proc |
                        pending[name] << proc
                    end
                end
            end

            def setup_association_export( association, options )
                export_associations( association.name, options == true ? {} : options )
            end
        end

    end

end
