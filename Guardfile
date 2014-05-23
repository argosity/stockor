# A sample Guardfile
# More info at https://github.com/guard/guard#readme

notification :terminal_notifier_guard

guard :jasmine, :port => 8888, :mount => '/', :console=>:always do
#guard :jasmine, port: 8888, server_env: :test, server: :'app:jasmine', :server_mount => '/specs'   do
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$}) { 'spec/javascripts' }
  watch(%r{spec/javascripts/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{spec/javascripts/fixtures/.+$})
  watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m| "spec/javascripts/#{ m[1] }_spec.#{ m[2] }" }
end
