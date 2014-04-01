require_relative "test_helper"

class PtLineTest < Skr::TestCase


    # def test_invoicing
    #     pt = pick_tickets(:first)

    #     inv = Invoice.new({ :pick_ticket=> pt })
    #     pt.lines.each{ |ptl|
    #         ptl.qty_to_ship = ptl.qty
    #         inv.lines.build({ pt_line: ptl })
    #     }

    #     inv.save!.must_equal true
    #     inv.lines.length.must_equal pt.lines.length

    #     il = inv.lines.first

    #     il.pt_line.wont_be_nil
    #     il.pt_line.qty_shipped.must_equal il.qty
    # end

end
