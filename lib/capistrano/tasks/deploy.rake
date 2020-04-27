namespace :deploy do

    desc 'Runs rake skrdb:migrate'
    task migrate: [:set_rails_env] do
        on roles(:db) do
            within release_path do
                with rails_env: fetch(:rails_env) do
                    execute :rake, 'skrdb:migrate'
                end
            end
        end
    end

    after 'deploy:updated', 'deploy:migrate'

    namespace :load do
        task :defaults do
            set :migration_role, fetch(:migration_role, :db)
            set :migration_servers, -> { primary(fetch(:migration_role)) }
        end
    end

end
