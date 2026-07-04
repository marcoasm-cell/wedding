# Restart the Delayed Job worker daemon(s) on each deploy.
#
# The app runs background jobs via `delayed_job_active_record` + the `daemons`
# gem (see bin/delayed_job). This task stops the old workers and starts fresh
# ones from the newly released code. The pid files live in shared/tmp/pids
# (a linked dir), so `restart` reliably finds and replaces running workers.

namespace :load do
  task :defaults do
    set :delayed_job_roles, :app
    set :delayed_job_workers, 1
  end
end

namespace :delayed_job do
  desc "Restart the Delayed Job workers"
  task :restart do
    on roles(fetch(:delayed_job_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          workers = Integer(fetch(:delayed_job_workers))
          execute :bundle, :exec, "bin/delayed_job", "-n", workers, "restart"
        end
      end
    end
  end

  desc "Start the Delayed Job workers"
  task :start do
    on roles(fetch(:delayed_job_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "bin/delayed_job", "-n", Integer(fetch(:delayed_job_workers)), "start"
        end
      end
    end
  end

  desc "Stop the Delayed Job workers"
  task :stop do
    on roles(fetch(:delayed_job_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "bin/delayed_job", "stop"
        end
      end
    end
  end
end

# Restart workers after the new release is published (alongside Puma).
after "deploy:published", "delayed_job:restart"
