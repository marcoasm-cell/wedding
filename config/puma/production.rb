# Production Puma configuration.
#
# Loaded automatically when the app is started with `puma -e production`
# (Puma auto-detects config/puma/<env>.rb). capistrano3-puma's systemd unit
# runs exactly that command, so this file drives the production server.

# Worker processes (forked). Set WEB_CONCURRENCY on the server; a common
# starting point is the number of CPU cores.
workers Integer(ENV.fetch("WEB_CONCURRENCY", 2))

# Threads per worker. Keep the max in sync with the DB pool (RAILS_MAX_THREADS,
# see config/database.yml).
max_threads = Integer(ENV.fetch("RAILS_MAX_THREADS", 5))
min_threads = Integer(ENV.fetch("PUMA_MIN_THREADS", max_threads))
threads min_threads, max_threads

# Load the app before forking workers for copy-on-write memory savings.
preload_app!

environment "production"

# Bind to a Unix socket that lives under the shared tmp/sockets directory
# (symlinked across releases). Point your reverse proxy (nginx/Caddy) at it.
# __dir__ is <release>/config/puma, so ../.. is the app root.
app_root = File.expand_path("../..", __dir__)
bind "unix://#{app_root}/tmp/sockets/puma.sock"

# To serve directly over TCP instead (e.g. no reverse proxy), replace the bind
# above with:
#   port ENV.fetch("PORT", 3000)

# Allow `bin/rails restart` and Puma phased restarts to work.
plugin :tmp_restart

# Re-establish the ActiveRecord connection in each forked worker.
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
