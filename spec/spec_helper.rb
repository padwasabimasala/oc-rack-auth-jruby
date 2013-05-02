require 'simplecov'
SimpleCov.start


require 'rack-octanner-auth'
require 'ostruct'
require 'json'

require 'webmock/rspec'
include WebMock::API

RSpec.configure do |config|
  config.order = "random"
end


Rack::Octanner::Auth.configure do |config|
  config.oauth_id = '1234'
  config.oauth_secret = 'secret'
end