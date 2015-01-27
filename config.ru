require 'slackattend'

$stdout.sync = true #if development?
Encoding.default_external = Encoding.find('UTF-8')
#\ -s puma -E production

Slackattend.setup
Slackattend.update_database
use Slackattend::WebsocketHandler
run Slackattend::App

