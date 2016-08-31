require 'active_record/validations'

module Skr

    class InvalidGlTransaction < ActiveRecord::RecordInvalid
    end


    module Concerns

        module HasGlTransaction

            extend ActiveSupport::Concern

            module InstanceMethods

                # N.B. We are overriding ActiveRecord::Base#save
                # This is so we can wrap the save call inside a {GlTransaction.record} block
                # which will collect any GlPostings and then collapse them down at the end of the block
                # in order to prevent multiple postings to the same account.
                def save(*)
                    opts = options_for_gl_transaction
                    # do nothing if the options specified an if clause and the method returns false
                    if opts.present? and opts.has_key?(:if) and self.send( opts[:if] ) == false
                        super
                    else
                        save_status = false
                        # First we wrap it up in our transaction since we don't have the benefit of
                        # save's rollback_active_record_state! block
                        # I'm tempted to appropriate it's usage, but am not since it's not documented (that I've found)
                        # and is thus likely to change
                        GlTransaction.transaction( requires_new: true ) do
                            # Enclose in GlTransaction#record block
                            gl_transaction = GlTransaction.record do
                                save_status = super # ActiveRecord::Base#save
                                # If save was successfull, pass attributes back to GlTransaction#record.
                                # Otherwise pass false back so it knows to not save the GlTransaction
                                save_status ? { attributes: self.send( opts[:attributes] ) } : false
                            end
                            # if we saved successfully, but the GlTransaction did not;
                            #   Copy the errors to the model and abort the transaction
                            if save_status && gl_transaction.errors.any?
                                self.errors[:gl_transaction] += gl_transaction.errors.full_messages
                                save_status = false
                                raise InvalidGlTransaction.new(gl_transaction)
                            end
                        end
                        return save_status
                    end
                end

                def attributes_for_gl_transaction
                    identifier = has_attribute?(:visible_id) ? visible_id : id
                    {
                        source: self,
                        location: try(:location) || Location.default,
                        description: "#{self.class.to_s.demodulize} #{identifier}"
                    }
                end
            end

            module ClassMethods

                def has_gl_transaction( options={} )
                    options.merge!( attributes: :attributes_for_gl_transaction )
                    cattr_accessor :options_for_gl_transaction
                    self.options_for_gl_transaction = options unless options.empty?
                    self.send :include, InstanceMethods
                end

            end

        end
    end
end
