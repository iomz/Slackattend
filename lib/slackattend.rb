%w(
  faye/websocket
  haml
  json
  open-uri
  sinatra/base
  slack
  yaml
).each { |lib| require lib }

Encoding.default_external = Encoding.find('UTF-8')

%w(
  core
  status_log
  current_member
  slack_client
  backend
  app
).each { |name| require_dependency File.expand_path("../slackattend/#{name}", __FILE__) }
