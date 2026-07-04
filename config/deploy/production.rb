server "89.40.13.86", user: "root", roles: %w{app db web}, primary: true

set :branch, "main"
set :rails_env, "production"
set :deploy_to, "/var/www/#{fetch(:application)}/production"