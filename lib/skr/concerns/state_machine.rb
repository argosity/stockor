require 'state_machine'

module Skr
    module Concerns


        # Models that use the {https://github.com/pluginaweek/state_machine state_machine}
        # gem to track object state
        module StateMachine
            extend ActiveSupport::Concern

            module ClassMethods

                # Mark class as a {https://github.com/pluginaweek/state_machine state_machine}
                #
                # Specifically it:
                #
                #   * Adds the methods in {InstanceMethods} to the class
                #   * Blacklists the "state" field so it cannot be set via the API
                #   * Allows access to the "state_event" pseudo field from the API
                def is_a_state_machine( options={} )
                    include InstanceMethods

                    export_methods :valid_state_events, :optional=>false
                    blacklist_json_attributes :state
                    whitelist_json_attributes :state_event
                end

            end

            module InstanceMethods

                # @return [Array of symbols] the available state_transistions
                def valid_state_events
                    state_transitions.map(&:event)
                end

            end


        end

    end
end
