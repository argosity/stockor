module Skr

    class InventoryAdjustment < Skr::Model

        has_visible_id
        has_gl_transaction if: :should_apply_gl?

        has_one :gl_transaction, :as=>:source, :inverse_of=>:source

        belongs_to :location, export: true
        belongs_to :reason, :class_name=>'IaReason', export: true

        has_many :lines, :class_name=>'IaLine', :inverse_of=>:inventory_adjustment, export: { writable:true }

        validates :reason, :location, :set=>true
        validate :ensure_state_is_savable
        validates_associated :lines

        delegate_and_export :location_code
        delegate_and_export :reason_code

        state_machine :initial => :pending do
            event :mark_applied do
                transition any => :applied
            end
            after_transition :to => :applied, :do => :apply_adjustment
        end

        private

        def ensure_state_is_savable
            if :applied == state_name && state_was == 'applied'
                errors.add('base' , "Cannot update record once it's approved and applied")
                return false
            end
        end

        def apply_adjustment
            self.transaction = GlTransaction.record({ source: self, location: location,
                                                      description: "IA #{self.visible_id}" }) do
                self.lines.each do | line |
                    next if line.is_applied?
                    line.unlock_adjusting{ line.adjust_qty! }
                end
                self.lines.reload
            end
            return self.transaction.errors.empty?
        end

    end


end # Skr module
