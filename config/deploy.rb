set :application, 'stockor-saas'
set :repo_url, 'file:///srv/git/stockor-saas.git'
set :deploy_to, '/srv/www/stockor'
set :passenger_restart_with_touch, true
set :conditionally_migrate, true
set :linked_files, %w(config/database.yml)
set :linked_dirs,  %w(public/files log)

set :rollbar_token, '0a6299a7577846c9a55c3c30028e6a55'
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }
