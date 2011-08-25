require 'bundler/capistrano'

set :application, 'torch'
set :repository,  'https://github.com/francocatena/torch.git'
set :deploy_to, '/var/rails/torch'
set :user, 'deployer'
set :group_writable, false
set :shared_children, %w(system log pids private public config)
set :use_sudo, false

set :scm, :git
set :branch, 'master'

role :web, 'fcatena.com.ar'
role :app, 'fcatena.com.ar'
role :db,  'fcatena.com.ar', primary: true

after 'deploy:symlink', 'deploy:create_shared_symlinks',
  'deploy:precomplile_assets'

namespace :deploy do
  task :start do
  end

  task :stop do
  end

  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  desc 'Creates the symlinks for the shared folders'
  task :create_shared_symlinks do
    shared_paths = []

    shared_paths.each do |path|
      shared_files_path = File.join(shared_path, *path)
      release_files_path = File.join(release_path, *path)

      run "ln -s #{shared_files_path} #{release_files_path}"
    end
  end
  
  desc 'precompile the assets'
  task :precomplile_assets, roles: :web, except: { no_release: true } do
    run "cd #{current_path}; rm -rf public/assets/*"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
end