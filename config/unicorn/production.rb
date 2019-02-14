worker_processes 2

working_directory "/srv/ror-blog/current"

listen "/srv/ror-blog/socket/.unicorn.sock", :backlog => 64
listen 8082, :tcp_nopush => true

timeout 30

pid "/srv/ror-blog/current/pids/unicorn.pid"

stderr_path "/srv/ror-blog/log/unicorn.stderr.log"
stdout_path "/srv/ror-blog/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
