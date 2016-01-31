require_relative '../../spec_helper'
require 'skr/jobs/fresh_books/retrieve'

class FreshBooksRetrieveSpec < Skr::TestCase

    def around(&block)
        VCR.use_cassette("freshbooks", record: :none) do
            block.call
        end
    end

    def test_record_retrieval
        job = Skr::Jobs::FreshBooks::Retrieve.perform_now(
            'testermctest-billing',
            'ba6642fa8d9b99e113ce0e5a1bf66de0'
        )
        data = job.job_status.data['output']

        assert_equal ['testermctest@argosity.com'],
                     data['staff'].map{|c| c['username'] }

        assert_equal ["ClientThree", "Organization Two", "Organization One"],
                     data['clients'].map{|c| c['organization'] }

        assert_equal ["Project1", "Project2"],
                     data['projects'].map{|c| c['name'] }

        assert_equal ['0000001'],
                     data['invoices'].map{|c| c['number'] }

        assert_equal ["7293", "7292", "2432", "2430"],
                     data['time_entries'].map{|c| c['time_entry_id'] }

    end


end
