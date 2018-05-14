# server "staging.avjunction.com", user: "deploy", roles: %w{app db web}
server "45.79.160.18", user: "deploy", roles: %w{app db web}
set :branch, ENV["CIRCLE_SHA1"] || ENV["REVISION"] || ENV["BRANCH_NAME"] || "develop"
