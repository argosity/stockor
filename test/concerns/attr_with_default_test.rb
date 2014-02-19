require_relative '../test_helper'

class AttrAccessorWithDefaultTest < Skr::TestCase

    Shared = Struct.new(:value)

    class AttrTestClass
        include Skr::Concerns::AttrAccessorWithDefault
        attr_accessor_with_default :as_proc, Proc.new{ 42 }
        attr_accessor_with_default :non_copying, ->{ "default string" }
        attr_accessor_with_default :shared, Shared.new('default')
        attr_accessor_with_default :non_shared, ->{ Shared.new('default') }
    end

    def test_access
        a = AttrTestClass.new
        b = AttrTestClass.new

        assert_equal 42, b.as_proc

        assert_equal "default string", b.non_copying

        b.non_copying = "A new string"

        assert_equal "default string", a.non_copying
        a.non_copying = "third value"
        assert_equal "A new string", b.non_copying


        assert_equal "default", a.shared.value
        assert_equal "default", b.shared.value

        a.shared.value = "a new value"

        assert_equal "a new value", a.shared.value
        assert_equal "a new value", b.shared.value

        a.non_shared.value = "a new value"
        assert_equal "a new value", a.non_shared.value
        assert_equal "default", b.non_shared.value

    end


end
