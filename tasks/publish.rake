namespace :publish do

    desc "generate and publish docs to stockor.org"
    task :docs => 'doc' do
        system( "rsync", "doc/", "-avz", "--delete", "stockor@stockor.org:~/docs/core")
    end

end
