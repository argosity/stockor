require_relative '../../spec_helper'

class FreshBooksImportSpec < Skr::TestCase

    def around(&block)
        VCR.use_cassette("freshbooks", VCR_OPTS) do
            block.call
        end
    end

    def perform_import(options = {})
        Skr::Jobs::FreshBooks::Import.perform_now(
            {
                "domain"=>"testermctest-billing",
                "api_key"=>"ba6642fa8d9b99e113ce0e5a1bf66de0",
                "stage"=>"complete",
                "ignored_ids"=>{
                    "clients"=>[], "projects"=>[],
                    "invoices"=>[], "time_entries"=>[], "staff"=>[]
                }
            }.merge(options)
        )
    end

    def test_import
        assert_difference ->{ Skr::Invoice.count }, 1 do
            assert_difference ->{ Skr::Customer.count }, 3 do
                perform_import
            end
        end
        inv = Skr::Invoice.find_by_visible_id('1')
        assert_equal inv.invoice_date.strftime('%Y-%m-%d'), '2016-01-26'
    end

    def test_invoice_balance
        perform_import
        inv = Skr::Invoice.find_by(visible_id: '1')
        assert_equal 2198.75, inv.total.to_f
        assert inv.fully_paid?
        assert_equal 3, inv.lines.count
        assert_equal 3, inv.lines.map(&:time_entry).compact.length
    end

    def test_ignored_ids
        perform_import({'ignored_ids'=> {"time_entries" => ['7293'], 'clients' => ['27454'] }})
        assert_nil Skr::TimeEntry.where("options ->>'freshbooks_id' = ?", '7293').first
        assert_nil Customer.where("options ->>'freshbooks_id' = ?", '27454').first
    end

    def test_user_mappings
        assert_no_difference ->{ Lanes::User.count } do
            perform_import({'user_mappings' => { '1' => '1' }})
        end
    end

    def test_customer_codes
        customer = skr_customer(:billy)
        assert_difference ->{ Skr::Customer.count }, 2 do
            assert_difference ->{ customer.invoices.count }, 1 do
                perform_import({'customer_codes' => {
                                    '27454' => 'FOO',
                                    '14694' => 'GOAT'
                                }})
                assert Skr::Customer.find_by_code('FOO')
            end
        end
    end

end
