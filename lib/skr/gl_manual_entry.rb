module Skr

    # Records a manual entry into the General Leger.
    # Most GL entries are triggered by system events such as an Inventory Receipt, or Invoice payment.
    # A manual entry differs in that it's performed, well *Manually*.
    # It's usually used to balance ledger accounts or as part of closing an accounting period.
    class GlManualEntry < Skr::Model

        has_visible_id

        is_immutable

        has_one :transaction, :class_name=>'GlTransaction', :as=>:source,
                :inverse_of=>:source, export: { writable: true }

        validates :transaction, :presence=>true

        before_create :copy_notes_to_transaction

        def description_for_gl_transaction(glt)
            "GLE #{self.visible_id}"
        end

        private

        def copy_notes_to_transaction
            self.transaction.description = self.notes[0..100]
        end

    end
end
