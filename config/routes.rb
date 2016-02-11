require 'stockor'

Lanes::API.routes.for_extension 'skr' do

    resources Skr::CustomerProject
    resources Skr::TimeEntry
    resources Skr::Customer
    resources Skr::Address
    resources Skr::GlAccount
    resources Skr::GlManualEntry
    resources Skr::GlPeriod
    resources Skr::GlPosting
    resources Skr::GlTransaction
    resources Skr::IaLine
    resources Skr::IaReason
    resources Skr::InvLine, indestructible: true
    resources Skr::InventoryAdjustment
    resources Skr::Invoice, indestructible: true
    resources Skr::Location
    resources Skr::PaymentTerm
    resources Skr::Sku
    resources Skr::SkuLoc
    resources Skr::SkuTran
    resources Skr::Uom
    resources Skr::Vendor

    resources Skr::PickTicket
    resources Skr::PtLine

    resources Skr::PoReceipt
    resources Skr::PorLine

    resources Skr::PurchaseOrder
    resources Skr::PoLine

    resources Skr::Voucher
    resources Skr::VoLine

    resources Skr::SalesOrder
    resources Skr::SoLine

    post 'invoices/from-time-entries.json',
         &Skr::Handlers::InvoiceFromTimeEntries.handler

    get 'print/:type/:id.pdf' do
        content_type 'application/pdf'
        form = Skr::Print::Form.new(params[:type], params[:id])
        form.as_pdf
    end

    post 'fresh-books-imports.json',
        &Skr::Handlers::FreshBooksImport.handler


end
