# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project (Git over HTTPS/SSH)
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# rbenv: run the correct Ruby/bundler on the server (see .ruby-version)
require "capistrano/rbenv"

# Bundler: `bundle install` on deploy, and map bins through `bundle exec`
require "capistrano/bundler"

# Rails: migrations + asset precompile (Tailwind builds during assets:precompile)
require "capistrano/rails/assets"
require "capistrano/rails/migrations"

# Puma app server, managed as a systemd (user) service
require "capistrano/puma"
install_plugin Capistrano::Puma          # puma:start / stop / restart / status ...
install_plugin Capistrano::Puma::Systemd # generate & manage the systemd unit

# Load custom tasks from `lib/capistrano/tasks/*.rake` (e.g. Delayed Job restart)
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
