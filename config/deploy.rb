set :application, 'artemix'
set :repo_url, 'git@github.com:leggers/artemix.git'
set :branch, 'master'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/artemix'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Symlink config files'
  task :symlink_config_files do
    sh "ln -nfs #{deploy_to}/shared/config/database.yml #{current_path}/config/database.yml"
  end

  desc 'Symlink public folder'
  task :symlink_public_folder do
    sh "ln -fs #{deploy_to}/public/ #{current_path}/public"
  end

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
  # after :finishing, 'deploy:symlink_config_files'
  # after :finishing, 'deploy:symlink_public_folder'
  after :finishing, 'deploy:restart'

end