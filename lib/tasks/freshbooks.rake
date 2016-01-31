require 'ruby-freshbooks'

desc 'write'
task :freshbooks, [:domain, :token] do |tt, args|
    args = {
        token: '5d81515650d8017950baf1e5574dd2bc',
        domain: 'argosity'
    }
    fb = FreshBooks::Client.new("#{args[:domain]}.freshbooks.com", args[:token])

    page = last_page = 1
    while page <= last_page
        fb.time_entry.list(per_page: 25, page: 0)
    end

    p c.time_entry.list
    binding.pry
#    puts 'fb'
end
