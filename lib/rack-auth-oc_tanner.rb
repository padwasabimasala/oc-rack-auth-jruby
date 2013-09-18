require 'simple-secrets'

module Rack
  module Auth
    module OCTanner
      autoload :Token, 'rack/auth/oc_tanner/token'
      autoload :AuthenticationFilter, 'rack/auth/oc_tanner/authentication_filter'
      autoload :SmD, 'rack/auth/oc_tanner/smd'
      autoload :ScopeList, 'rack/auth/oc_tanner/scope_list'
      autoload :Scopes, 'rack/auth/oc_tanner/scopes'
      autoload :SmallHour, 'rack/auth/oc_tanner/small_hour'
    end
  end
end

