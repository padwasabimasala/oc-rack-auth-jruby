require File.expand_path('../lib/rack-octanner-auth/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ['Jay Wagnon']
  gem.email = ['jay.wagnon@octanner.com']
  gem.description = %q{Rack module for handling OC Tanner OAuth2 tokens.}
  gem.summary = gem.description
  gem.homepage = 'https://github.com/octanner/rack-octanner-auth'

  gem.executables = `git ls-files -- bin/*`.split('\n').map{ |f| File.basename(f) }
  gem.files = `git ls-files`.split('\n')
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split('\n')
  gem.name = 'rack-octanner-auth'
  gem.require_paths = ['lib']
  gem.version = '1.0.0'

  gem.add_runtime_dependency 'oauth2'
end