require 'simplecov'
SimpleCov.start


require 'rack-auth-oc_tanner'
require 'ostruct'
require 'json'

require 'webmock/rspec'
include WebMock::API

RSpec.configure do |config|
  config.order = "random"
end
