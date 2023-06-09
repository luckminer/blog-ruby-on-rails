# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'ror-blog'
set :repo_url, 'git@gitlab.com:tty8747/ror-blog.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/srv/ror-blog'
set :deploy_via, :copy
set :keep_releases, 5

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.3'

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
set :rbenv_path, '/home/deploy/.rbenv'
set :bundle_env_variables, { 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 1 }

set :unicorn_pid, '/srv/ror-blog/shared/pids/unicorn.pid'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
# set :linked_files, fetch(:linked_files, []).push('config/unicorn/production.rb', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
# set :linked_dirs, fetch(:linked_dirs, []).push('bundle', 'config', 'public', 'run', 'tmp', 'pids', 'sockets', 'vendor')
set :linked_dirs, fetch(:linked_dirs, []).push('pids')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after 'symlink:release', 'deploy:migrate', 'unicorn:restart'

  after :finishing, 'deploy:cleanup', "deploy:update_code"

# after ':symlink:release' do
   #execute unicorn:restart
# end
 
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
	  within release_path do
	    execute :rake, 'cache:clear'
	  end
        end
      end
end
