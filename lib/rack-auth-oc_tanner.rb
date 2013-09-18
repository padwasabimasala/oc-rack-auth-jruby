require 'simple-secrets'

module Rack
  module Auth
    autoload :OCTanner, 'rack/auth/oc_tanner'
    autoload :AuthenticationFilter, 'rack/auth/authentication_filter'
    autoload :SmD, 'rack/auth/smd'
    autoload :ScopeList, 'rack/auth/scope_list'
    autoload :Scopes, 'rack/auth/scopes'
    autoload :SmallHour, 'rack/auth/small_hour'
  end
end

