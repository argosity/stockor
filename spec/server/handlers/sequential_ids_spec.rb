require_relative '../spec_helper'

class SequentialIdsSpec < Skr::TestCase

    subject { Skr::Handlers::SequentialIds }

    let (:authentication) { Lanes::API::AuthenticationProvider.new({}) }
    let (:controller)     { subject.new( Skr::Invoice, authentication, {}, {} ) }
    let (:sids)    { controller.show[:data]['ids'] }

    it "retrieves the list of sequential ids" do
        assert_kind_of Array, sids

        sids[0...sids.length-2].each do | si |
            assert_includes Skr::Handlers::SequentialIds::TYPES, si['id']
            assert_kind_of Fixnum, si['count']
        end
        bank = skr_bank_account(:checking)
        assert sids.last['id'], Payment::SEQUENTIAL_ID_PREFIX + bank.id.to_s
    end

end
