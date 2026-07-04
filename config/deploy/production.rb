# Production stage.
#
# TODO: replace the host below with your server's hostname or IP, and set the
# SSH user that owns #{deploy_to}. `roles` map servers to the app/web/db roles;
# for a single-server deploy one host fills all three.
#
# You can override any of these with env vars at deploy time, e.g.
#   DEPLOY_HOST=1.2.3.4 DEPLOY_USER=deploy cap production deploy

server ENV.fetch("DEPLOY_HOST", "your-server.example.com"),
       user: ENV.fetch("DEPLOY_USER", "deploy"),
       roles: %w[app web db]

# SSH options for connecting to the server.
set :ssh_options, {
  forward_agent: true,
  keys: [ENV["DEPLOY_SSH_KEY"]].compact,
  # auth_methods: %w[publickey],
}
