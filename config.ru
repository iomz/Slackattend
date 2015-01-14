require 'app'
require 'slackattend'

$stdout.sync = true #if development?
use Slackattend::Backend
run Slackattend::App

