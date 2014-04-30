set :stage, :production
set :rails_env, 'production'
set :migration_role, 'db'

role :app, %w{deploy@eglantine.bombsheller.com}
role :web, %w{deploy@eglantine.bombsheller.com}
role :db, %w{deploy@eglantine.bombsheller.com}
