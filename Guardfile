require "lanes/guard_tasks"

Lanes::GuardTasks.run(self, name: "skr") do | tests |

    tests.client do

    end

    tests.server do
        watch(%r{^templates/print/*}) { "spec/server/print/pdf_spec.rb" }
    end

end
