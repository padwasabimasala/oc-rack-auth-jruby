class HelloController < ApplicationController

  before_filter Rack::Auth::AuthenticationFilter.new

  def hello
    user = env['octanner_auth_user']['name']
    render json: { message: "Hello there, #{user}!" }
  end
end
