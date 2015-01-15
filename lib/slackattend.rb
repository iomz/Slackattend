%w(
  faye/websocket
  haml
  json
  open-uri
  puma
  sinatra/activerecord
  sinatra/base
  slack
  yaml
).each { |lib| require lib }

%w(
  core
  status_log
  current_member
  slack_client
  backend
  app
).each { |name| require_dependency File.expand_path("../slackattend/#{name}", __FILE__) }
