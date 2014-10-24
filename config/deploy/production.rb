set :stage, :production
set :rails_env, 'production'
set :migration_role, 'db'

role :app, %w{deploy@titica.bombsheller.com}
role :web, %w{deploy@titica.bombsheller.com}
role :db, %w{deploy@titica.bombsheller.com}
