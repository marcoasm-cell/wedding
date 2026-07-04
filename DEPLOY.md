# Deployment (Capistrano)

This app deploys with [Capistrano](https://capistranorb.com), pulling source
from a **Git repo over HTTPS**, running Ruby via **rbenv**, serving with
**Puma** managed as a **systemd** service, and running **Delayed Job** workers
as background daemons.

## Files

| File | Purpose |
|------|---------|
| `Capfile` | Loads Capistrano plugins (rbenv, bundler, rails, puma, custom tasks) |
| `config/deploy.rb` | Shared settings: repo, paths, linked files/dirs, Puma, Delayed Job |
| `config/deploy/production.rb` | The `production` server (host, user, roles, SSH) |
| `config/puma/production.rb` | Production Puma config (auto-loaded by `puma -e production`) |
| `lib/capistrano/tasks/delayed_job.rake` | Restarts Delayed Job workers on each deploy |

## 1. Fill in the placeholders

Edit these (or pass them as env vars at deploy time):

- `config/deploy.rb` → `:repo_url`, `:deploy_to`
- `config/deploy/production.rb` → `server` host, `user`

Env-var overrides:

```bash
REPO_URL=https://github.com/your-org/wedding_photos.git \
DEPLOY_TO=/var/www/wedding_photos \
DEPLOY_HOST=1.2.3.4 DEPLOY_USER=deploy \
bundle exec cap production deploy
```

For a **private repo over HTTPS**, either embed a token in the URL
(`https://<user>:<token>@github.com/...`) or configure a git credential helper
for the deploy user on the server.

## 2. Server prerequisites (once per server)

- A deploy user with SSH access and ownership of `deploy_to`.
- **rbenv** installed for that user, with Ruby `3.4.2` (`.ruby-version`) installed.
- **MySQL** running, with a `wedding_photos_production` database and a
  `wedding_photos` user.
- A reverse proxy (nginx/Caddy) terminating TLS and proxying to the Puma Unix
  socket at `<deploy_to>/shared/tmp/sockets/puma.sock`. (The app sets
  `config.force_ssl = true`, so it must be served over HTTPS.)
- `systemd` **user lingering** enabled so the Puma user service survives logout.
  capistrano3-puma enables this automatically during `puma:install`.

## 3. Provide secrets on the server

Capistrano symlinks a few things from `shared/` on every deploy. Create them
once:

```bash
# The Rails master key (gitignored) — decrypts config/credentials.yml.enc
mkdir -p <deploy_to>/shared/config
scp config/master.key deploy@host:<deploy_to>/shared/config/master.key
```

The **production database password** is read from
`ENV["WEDDING_PHOTOS_DATABASE_PASSWORD"]` and, if unset, falls back to
encrypted credentials at `database.password`. To use credentials, run locally:

```bash
EDITOR="code --wait" bin/rails credentials:edit
```

and add:

```yaml
database:
  password: your_production_db_password
```

With `master.key` linked, migrations, Puma, and Delayed Job all decrypt this
automatically — no extra env plumbing required. Alternatively, inject the env
var into the Puma service via `:puma_service_unit_env_vars` /
`:puma_service_unit_env_files` in `config/deploy.rb`.

## 4. First deploy

```bash
bundle exec cap production deploy:check   # verify dirs, linked files, git access
bundle exec cap production puma:install   # create + enable the Puma systemd unit (once)
bundle exec cap production deploy
```

`deploy` will: fetch the code, `bundle install` (without dev/test), run
`db:migrate`, precompile assets (Tailwind builds automatically), then restart
Puma and the Delayed Job workers.

## Useful tasks

```bash
bundle exec cap production puma:status        # Puma service status
bundle exec cap production puma:restart        # restart Puma
bundle exec cap production delayed_job:restart # restart background workers
bundle exec cap production deploy:rollback      # roll back to the previous release
```

## Notes

- **Active Storage** uploads live in `storage/`, which is a linked dir
  (`shared/storage`) so uploaded photos persist across releases. For multi-server
  or resilient storage, switch `config/environments/production.rb` to an S3/GCS
  service in `config/storage.yml`.
- JS uses **importmap** (no Node/Yarn build step needed).
- `keep_releases` is 5; older releases are pruned automatically.
