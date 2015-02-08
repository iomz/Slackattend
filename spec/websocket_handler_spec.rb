# encoding: UTF-8
require 'spec_helper'
require 'rspec'

RSpec.describe Slackattend::WebsocketHandler do
  describe '#parse_event_data' do
    it 'should return a hash' do
      Slackattend::WebsocketHandler.parse_event_data({'user' => 'hoge', 'action_name' => 'in'})
    end
  end
end
