require_relative '../test_helper'

class PubSubTest < Skr::TestCase

    class EventTester
        def self.after_save(*args);    end
        def self.after_create(*args);  end
        def self.after_update(*args);  end
        def self.after_destroy(*args); end

        include Skr::Concerns::PubSub

        def trigger( event, *args )
            fire_event(event, *args )
        end
    end

    class Ev1 < EventTester
        has_additional_events :test_one
    end

    class Ev2 < EventTester
        has_additional_events :test_two
    end


    def test_event_name_registration
        assert_equal [ :save, :create, :update, :destroy ],EventTester.valid_event_names
        assert_equal [ :save, :create, :update, :destroy, :test_one ],Ev1.valid_event_names
    end

    def test_only_valid
        assert_raises( EventTester::InvalidEvent) do
            EventTester.observe(:invalid_event) do | ev |
            end
        end
        assert_raises( EventTester::InvalidEvent) do
            EventTester.observe(:save) do | ev |
            end
            EventTester.new.trigger(:invalid_event)
        end
        assert_raises( EventTester::InvalidEvent) do
            Ev1.observe(:test_two) do | ev |
            end
        end
        assert_raises( EventTester::InvalidEvent) do
            Ev2.observe(:test_one) do | ev |
            end
        end
        begin
            Ev2.observe(:test_one) do | ev |
            end
        rescue EventTester::InvalidEvent=>e
            assert_equal 'test_one is not a valid event for PubSubTest::Ev2', e.to_s
        end
    end

    def test_subscription
        EventTester.observe(:save) do | ev |
        end
    end
    def test_firing
        results=[]
        Ev1.observe(:test_one) do | ev, one, two |
            results = [ ev, one, two ]
        end
        evt=Ev1.new
        evt.trigger( :test_one, 3, 5 )
        assert_equal [ evt, 3, 5 ], results

        evt.trigger( :test_one, 'foo' )
        assert_equal [ evt, 'foo', nil ], results
    end


    def test_firing_with_assertsions
        assert_event_fires( Ev1, :test_one ) do
            Ev1.new.trigger( :test_one, 3, 5 )
        end
        assert_equal [ 3, 5 ], last_event_results[1..-1]
    end

end
