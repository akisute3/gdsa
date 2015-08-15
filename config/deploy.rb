# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'gdsa'
set :repo_url, 'https://github.com/akisute3/gdsa.git'
set :rbenv_ruby, '2.2.1'
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"


namespace :deploy do
  after :publishing, :restart do
    invoke 'unicorn:restart'
  end

  after :migrate, :seed do
    within current_path do
      execute :bundle, :exec, :rake, 'db:seed_fu'
    end
  end
end
