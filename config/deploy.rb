set :application, 'artemix'
set :repo_url, 'git@github.com:leggers/artemix.git'

set :user, 'leggers'
set :domain, 'artemix.bombsheller.com'
set :application, 'artemix'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/home/leggers/artemix'
set :scm, :git
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :normalize_asset_timestamps, false
set :rails_env, :production

role :app, domain
role :web, domain
role :db, domain :primary => true


# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
