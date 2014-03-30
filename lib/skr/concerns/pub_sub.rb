module Skr::Concerns

    module PendingEventListeners
        # @private
        @@listeners = Hash.new{ |hash, klass| hash[klass] = Hash.new{ |kh, event| kh[event]=Array.new } }
        # @api private
        def self.all
            @@listeners
        end
    end


    # Event subscription and publishing for Stockor Models
    # Every model has certain built-in events (:save, :create, :update, :destroy)
    # And may also implement custom events that reflect the models domain
    # @example Send an email when a customer's name is updated
    #   Customer.observe(:update) do |customer|
    #       Mailer.notify_billing(customer).deliver if customer.name_changed?
    #   end
    # @example Update some stats when a Sku's qty is changed
    #   Sku.observe(:qty_changed) do | sku, location, old_qty, new_qty |
    #       Stats.refresh( location )
    #   end
    module PubSub
        extend ActiveSupport::Concern

        class InvalidEvent < RuntimeError
        end

        included do | base |

            class_attribute :valid_event_names
            class_attribute :_event_listeners
            self.valid_event_names = [ :save, :create, :update, :destroy ]

            after_save    :fire_after_save_events
            after_create  :fire_after_create_events
            after_update  :fire_after_update_events
            after_destroy :fire_after_destroy_events
        end

        module ClassMethods
            def inherited(base)
                super
                klass = base.to_s.gsub(/Skr::/,'')
                if PendingEventListeners.all.has_key?( klass )
                    events = PendingEventListeners.all.delete(klass)
                    events.each{ | name, procs | base.event_listeners[name] += procs  }
                end
            end

            def event_listeners
             self._event_listeners ||= Hash.new{ |hash, key| hash[key]=Array.new }
            end

            def _add_event_listener( name, proc )
                self.event_listeners[name].push( proc ) unless self.event_listeners[name].include?(proc)
            end

            def observe( event, &block )
                _ensure_validate_event( event )
                _add_event_listener( event.to_sym, block )
            end

            def _ensure_validate_event(event)
                unless self.valid_event_names.include?(event.to_sym)
                    raise InvalidEvent.new("#{event} is not a valid event for #{self}")
                end
            end

            protected

            def has_additional_events( *names )
                self.valid_event_names += names.map{ |name| name.to_sym }
            end
        end

        protected
        def fire_after_destroy_events
            _fire_event(:update, self )
        end
        def fire_after_update_events
            _fire_event(:update, self )
        end
        def fire_after_create_events
            _fire_event(:create, self )
        end
        def fire_after_save_events
            _fire_event( :save, self )
        end

        def fire_event( name, *arguments )
            self.class._ensure_validate_event( name )
            arguments.unshift( self )
            _fire_event( name, *arguments )
        end

        private
        def _fire_event( name, *arguments )
            self.class.event_listeners[ name.to_sym ].each{ | block | block.call(*arguments) }
            return true
        end
    end

end
