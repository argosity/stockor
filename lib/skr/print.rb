require 'erb_latex'

module Skr
    class Print
        ROOT = Pathname.new(__FILE__).dirname.join("../../templates/print")

        def initialize(form, id)
            @model = case form
                when 'sales-orders' then SalesOrder.find(id)
                when 'invoices'     then Invoice.find(id)
                else
                    raise "Unable to find model for #{form}"
                end
            @form  = form
        end

        def output
            data = {}
            data[ @form.tableize.singularize ] = @model

            tmpl = ErbLatex::Template.new( ROOT.join(@form + '.tex'),
                                           :partials_path => ROOT.join('partials'),
                                           :packages_path => ROOT.join('packages'),
                                           :layout   => ROOT.join('layout.tex'),
                                           :data     => data
                                         )
            tmpl.to_stringio
        end
    end
end
