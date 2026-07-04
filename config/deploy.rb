# config valid for current version and patch releases of Capistrano
lock "~> 3.20"

set :application, "wedding_photos"

# --- Source code (Git over HTTPS) ---------------------------------------------
# TODO: point this at your repository. For a private repo over HTTPS, either
# embed a token (https://<user>:<token>@host/...) or configure a git credential
# helper on the server for the deploy user.
set :repo_url, "https://m_marques:glpat-utb8QDK88tOyq1oSo2kwA2M6MQpvOjEKdTpudHB6OA8.01.170qcrvzn@gitlab.com/m_marques/wedding.git"
set :branch, ENV.fetch("BRANCH", "main")

# --- Paths --------------------------------------------------------------------
# TODO: absolute path where releases live on the server (must be writable by the
# deploy user). Structure: #{deploy_to}/{current,releases,shared,repo}
set :deploy_to, ENV.fetch("DEPLOY_TO", "/var/www/wedding_photos")

# --- rbenv --------------------------------------------------------------------
# Pin to the version in .ruby-version so the server uses the same Ruby.
set :rbenv_type, :user           # or :system, depending on how rbenv is installed
set :rbenv_ruby, File.read(".ruby-version").strip
set :rbenv_map_bins, %w[rake gem bundle ruby rails puma pumactl]

# --- Rails env ----------------------------------------------------------------
set :rails_env, "production"

# --- Files & directories shared across releases -------------------------------
# master.key is gitignored, so it lives once in shared/ and is symlinked in.
append :linked_files, "config/master.key"

# Persist logs, pids, sockets, precompiled assets, the bundle, and — critically —
# Active Storage uploads (config/storage.yml `local` service -> ./storage).
append :linked_dirs,
       "log",
       "tmp/pids",
       "tmp/cache",
       "tmp/sockets",
       "public/assets",
       "storage"

# --- Bundler ------------------------------------------------------------------
# Don't install development/test gems on the server.
set :bundle_without, "development test"

# --- Releases -----------------------------------------------------------------
set :keep_releases, 5

# --- Puma (capistrano3-puma, systemd user service) ----------------------------
# Bind is defined in config/puma/production.rb (a Unix socket under tmp/sockets).
# The service unit is created by `cap production puma:install` (run once).
set :puma_env, fetch(:rails_env)
# set :puma_systemctl_user, :system  # uncomment to run Puma as a system service (needs sudo)

# Runtime environment variables for the Puma service can be injected here, e.g.:
# set :puma_service_unit_env_vars, ["WEB_CONCURRENCY=2", "RAILS_MAX_THREADS=5"]
# or from a file on the server:
# set :puma_service_unit_env_files, -> { ["#{shared_path}/config/app.env"] }

# --- Delayed Job --------------------------------------------------------------
# Restarted after each deploy by lib/capistrano/tasks/delayed_job.rake.
set :delayed_job_workers, Integer(ENV.fetch("DELAYED_JOB_WORKERS", 1))
