project_name = 'ror-blog'
root = "/srv/#{ project_name }/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.stderr.log"
stdout_path "#{root}/log/unicorn.stdout.log"

listen "#{root}/tmp/sockets/unicorn.sock"
worker_processes 2
timeout 30
