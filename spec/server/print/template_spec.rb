require_relative '../spec_helper'

class PrintTemplateSpec < Skr::TestCase

    let(:template) { Skr::Print::Template.get('sales_order') }

    it "can list templates" do
        assert_includes Skr::Print::Template.definitions.map(&:name), 'sales_order'
        assert_includes Skr::Print::Template.definitions.map(&:name), 'invoice'
    end

    it 'lists choices' do
        assert_includes template.choices, 'default'
    end

    it 'gets model class' do
        assert_equal Skr::SalesOrder, template.model
    end

    describe 'path' do

        it 'defaults to "default"' do
            assert_equal Skr::Print::ROOT.join('types','sales_order','default.tex'),
                         template.path_for_record(Skr::SalesOrder.first)
        end

        it 'defaults to default if form doesnt exist' do
            so = Skr::SalesOrder.first
            so.form = 'a-custom-form'
            assert_equal Skr::Print::ROOT.join('types','sales_order','default.tex'),
                         template.path_for_record(so)
        end

    end

end
