require 'logger'

module Rack
  module Auth
    class OCTanner
      def initialize(app, options = {})
        if ENV['RACK_AUTH_OCTANNER_DEBUG'] || !options[:log]
          @logger = ::Logger.new(STDERR)
        else
          @logger = options[:log]
        end
        @app = app
        @options = options
      end

      def token_overridden?
        unless instance_variable_defined? :@token_overridden
          @token_overridden = !!ENV['OCTANNER_AUTH_TOKEN']
        end
        @token_overridden
      end

      def call(env)
        @env = env.dup
        begin
          @env['octanner_auth_user'] = decode_token token
        rescue StandardError => e
          @logger.error e
          @logger.error e.backtrace[0..9].join("\n")
        end
        @app.call(@env)
      end

      def decode_token(token)
        return nil if token.nil? || token.empty?
        debug "Decoding Token: #{token.inspect} with #{@options[:key]}"
        user = packet.unpack(token)
        user['token'] = token if user
        debug "Decoded Token: #{user.inspect}"
        user
      end

      private

      def token
        if token_overridden?
          token = ENV['OCTANNER_AUTH_TOKEN'] 
        else
          token = ENV['OCTANNER_AUTH_TOKEN'] = token_from_headers || token_from_params
        end
      end

      def request
        request ||= Rack::Request.new @env  # todo is 'request' a local variable here? why?
      end

      def token_from_params
        request.params['access_token']
      end

      def token_from_headers
        request.env['HTTP_AUTHORIZATION'] &&
        !request.env['HTTP_AUTHORIZATION'][/(oauth_version='1.0')/] &&
        request.env['HTTP_AUTHORIZATION'][/^Token token=?([^\s]*)$/, 1]
      end

      def packet
        @packet ||= SimpleSecrets::Packet.new @options[:key]
      end

      private
      def debug(msg)
        @logger.debug "Rack::Auth::OCTanner #{msg.inspect}"
      end
    end
  end
end

