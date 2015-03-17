require 'stockor'

Lanes::API.routes.draw do
    resources Skr::Customer
    resources Skr::Address
    resources Skr::GlAccount
    resources Skr::GlManualEntry
    resources Skr::GlPeriod
    resources Skr::GlPosting
    resources Skr::GlTransaction
    resources Skr::IaLine
    resources Skr::IaReason
    resources Skr::InvLine
    resources Skr::InventoryAdjustment
    resources Skr::Invoice
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


end
