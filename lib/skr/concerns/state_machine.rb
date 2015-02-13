require 'aasm' # Acts As State Machine

module Skr
    module Concerns


        # Models that use the {https://github.com/aasm/aasm}
        # gem to track object state
        module StateMachine

            extend ActiveSupport::Concern

            module ClassMethods

                # Mark class as a StateMachine {https://github.com/aasm/aasm}
                #
                # Specifically it:
                #
                #   * Adds the methods in {InstanceMethods} to the class
                #   * Blacklists the "state" field so it cannot be set via the API
                #   * Allows access to the "state_event" pseudo field from the API
                #   * Sets up the aasm library with the contents of &block
                def state_machine( options={}, &block )
                    include InstanceMethods
                    include AASM
                    aasm( options.merge( column: 'state' ), &block )

                    whitelist_attributes :state_event

                    export_methods :valid_state_events, :optional=>false
                    blacklist_attributes :state

                    before_save :fire_state_machine_event_on_save
                end

            end

            module InstanceMethods

                def fire_state_machine_event_on_save
                    return unless state_event.present?
                    event_name = state_event.to_sym
                    if valid_state_events.include?( event_name )
                        self.send( :aasm_fire_event, event_name,  {:persist=>false} )
                    else
                        errors.add(:state_event, "is not valid")
                        false
                    end
                end

                # @return [Array of symbols] the available state_transistions
                def valid_state_events
                    aasm.events
                end

            end

        end

    end
end
