require "lanes/spec_helper"


class CodeIdentifierTest < Lanes::TestCase

    class CodeIdentifierTestModel
        class_attribute :blocks
        attr_accessor :code

        include Lanes::Concerns::CodeIdentifier

        def self.before_validation( opts={}, &block )
            self.blocks||=[]
            self.blocks.push( block )
        end

        def self.validates( *opts )
        end

        def run_validations
            self.class.blocks.each{ |b| self.instance_eval(&b) }
        end

        def [](name)
            :name == name ? 'A Long String of Nonsense' : ''
        end

        has_code_identifier :from => :name
    end

    def test_that_it_uppercases
        ci = CodeIdentifierTestModel.new
        ci.code='test'
        ci.run_validations
        assert_equal 'TEST', ci.code
    end

    def test_that_it_generates
        ci = CodeIdentifierTestModel.new
        ci.run_validations
        assert ci.code.present?, "Code wasn't auto-generated"
        assert_equal 'ALOSTOFNON',  ci.code
    end

end
