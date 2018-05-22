# server "dev.avjunction.com", user: "deploy", roles: %w{app db web}
server "45.79.181.49", user: "deploy", roles: %w{app db web}
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :rails_env, :dev
