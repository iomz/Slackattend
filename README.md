# slackattend
*An attendance management web application for a team using Slack*

`slackattend` is a sinatra-based web application designed to work with a Slack account.
Beef up teammates motivations by visualizing your presence in your office!

## Get started
Get your Slack API token (https://api.slack.com/web) and fill in the config file `conf.yml`

```sh
% git clone -b include-vendor git@github.com:iomz/slackattend.git
% gem install bundler foreman
% bundle install --path vendor/bundle
% bundle exec rake db:migrate
% foreman start
```

## Thanks
* https://github.com/olton/Metro-UI-CSS
* https://github.com/daneden/animate.css
* https://github.com/faye/faye-websocket-ruby

## License
slackattend is licensed under the MIT license. (http://opensource.org/licenses/MIT)
