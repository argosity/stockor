notification :growl

guard :minitest, :all_on_start => true do
    watch(%r{^test/test_helper\.rb}) { 'test' }

    watch(%r{^test/.+_test\.rb})
    watch(%r{^test/fixtures/skr/(.+)s\.yml})   { |m| "test/#{m[1]}_test.rb" }

    watch(%r{^lib/skr/(.+)\.rb})               { |m| "test/#{m[1]}_test.rb"          }
    watch(%r{^lib/skr/core/(.+)\.rb})          { |m| "test/core/#{m[1]}_test.rb"     }
    watch(%r{^lib/skr/concerns/(.+)\.rb})      { |m| "test/concerns/#{m[1]}_test.rb" }

end
