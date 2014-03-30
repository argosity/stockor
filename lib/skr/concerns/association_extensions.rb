module Skr::Concerns


    # Custom implentation of has_many and belongs_to
    #
    module AssociationExtensions

        extend ActiveSupport::Concern

        module ClassMethods

            def has_one(name, scope = nil, options = {})
                opts = extract_private_options( scope, options )
                assoc = super
                handle_private_options( assoc, opts ) unless opts.empty?
                assoc
            end

            def belongs_to(name, scope = nil, options = {} )
                opts = extract_private_options( scope, options )
                assoc = super
                handle_private_options( assoc, opts ) unless opts.empty?
                assoc
            end

            def has_many(name, scope=nil,options={}, &extension )
                opts = extract_private_options( scope, options )
                assoc = super
                handle_private_options( assoc, opts ) unless opts.empty?
                assoc
            end

            private

            def handle_private_options( assoc, opts )
                setup_listeners( assoc, opts[:listen] ) if opts[:listen]
                setup_association_export( assoc, opts[:export] ) if opts[:export]
            end

            def extract_private_options( scope, options )
                if scope.is_a?(Hash)
                    scope.extract!( :export, :listen )
                else
                    options.extract!( :export, :listen )
                end
            end

            # This gets complex since we
            #   First setup proc's for each listener,
            #   then attempt to load the associations's class
            #   If that succeds, we're done, otherwise we add it
            #   to PubSub's pending queue
            def setup_listeners( assoc, listeners )
                targets = {}
                if listeners.any? && assoc.options[:inverse_of].nil?
                    Skr::Core.logger.warn "Setting listener on #{name}##{assoc.name} but the assocation does not have " +
                                          "an inverse_of specified. This will almost certainly fail."
                                          binding.pry
                end
                listeners.each do | name, target |
                    targets[ name ] = Proc.new{ | record, *args |
                        record.send( assoc.inverse_of.name ).send( target, *( [record] + args ) )
                        binding.pry unless assoc.inverse_of

                    }
                end
                begin
                    klass = assoc.klass # This will throw if the class hasn't been loaded yet
                    targets.each{ | name, proc | klass._add_event_listener( name, proc ) }
                rescue NameError=>e
                    pending = PendingEventListeners.all[assoc.class_name]
                    targets.each do | name, proc |
                        pending[name] << proc
                    end
                end
            end

            def setup_association_export( assoc, options )
                export_associations( assoc.name, options == true ? {} : options )
            end
        end

    end

end
