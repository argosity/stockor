require_relative '../spec_helper'

class InvoiceFromTimeEntriesSpec < Skr::TestCase

    subject { Skr::Handlers::InvoiceFromTimeEntries }
    let (:project) { skr_customer_project(:goatpens) }
    let (:invoice) {
        subject.new(
            project.id, project.time_entries.map(&:id), 'po_num' => 'Testing Only!'
        ).build_invoice
    }
    let (:time_entry) { skr_time_entry(:siteprep) }
    let (:line)       { invoice.lines.first }

    it "raises exception if ids are not found" do
        assert_raises(ActiveRecord::RecordNotFound) {
            subject.new(
                project.id, [12345], 'po_num' => 'Testing Only!'
            ).build_invoice
        }
    end

    it "sets attributes on invoice" do
        assert_kind_of Skr::Invoice, invoice
        assert_equal invoice.customer, project.customer
        assert_equal 'Testing Only!', invoice.po_num
        assert_equal invoice.customer_project, project
    end

    it "creates lines on invoice" do
        assert line, 'did not add a line to invoice'
        assert_equal line.time_entry, time_entry
        assert line.sku_loc, "didn't set sku loc"
        assert_equal project.rates['hourly'], line.price
        assert_equal time_entry.description, line.description
        assert_equal 8.5, line.qty
    end

    it "creates savable invoice" do
        assert invoice.save, "Invoice failed to save, errors: #{invoice.errors.full_messages}"
    end

    it "marks time entry as invoiced after save" do
        invoice.save!
        time_entry.reload
        assert time_entry.inv_line, "invoice line wasn't set on time entry"
        assert time_entry.is_invoiced, "time entry wasn't marked as invoiced after save"
    end
end
