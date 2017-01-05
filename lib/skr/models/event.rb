module Skr

    class Event < Model

        has_code_identifier from: :title

        has_one :photo, as: :owner, :class_name=>'Lanes::Asset',
                export: { writable: true }, dependent: :destroy

        has_one :presents_logo,  -> { where owner_type: "PresentsLogo"},
                class_name: 'Lanes::Asset', foreign_key: :owner_id,
                foreign_type: :owner_type, dependent: :destroy,
                export: { writable: true }

        belongs_to :sku, export: { writable: true }

        has_many :invoice_xrefs, class_name: 'Skr::EventInvoiceXref'

        has_many :invoices, class_name: 'Skr::Invoice', through: :invoice_xrefs

        has_many :invoice_lines, class_name: 'Skr::InvLine', through: :invoices,
                 source: :lines, extend: Concerns::INV::Lines

        validates :title, :sku, presence: true

        def qty_remaining
            if max_qty.nil? || max_qty <= 0
                nil
            else
                max_qty - invoice_lines.ea_qty.to_i
            end
        end

        def get_presents_logo
            presents_logo.present? ? presents_logo : Location.default.get_logo
        end

    end

end
