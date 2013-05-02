rack-auth-oc_tanner
===================

Rack module for handling OC Tanner OAuth2 tokens.



## Getting Started

```ruby
gem 'rack-auth-oc_tanner', git: 'git@github.com:octanner/rack-auth-oc_tanner.git'
```

Then run the bundle command to install it.



## Rails Intergration

### Configuration

Add the following to your config/applications.rb file

```ruby
config.middleware.use Rack::Auth::OCTanner, client_id: 'some_id', client_secret: 'some_secret'
```

The `client_id` and `client_secret` are the credentials used to access the OAuth2 provider service to validate tokens and retrieve user information.

Other optional parameters that can be included are:

`site` - the OAuth2 provider site host

`authorize_url` - absolute or relative URL path to the Authorization endpoint

`token_url` - absolute or relative URL path to the Token endpoint


### Authenticating Requests

The `Rack::Auth::OCTanner` middleware will look for an OAuth2 token in the request parameters or headers, and will attempt to validate that token.  If the validation succeeds, the middleware will add two objects to the request environment:

`env['oauth2_token']` - An `OAuth2::AccessToken` object, which can be used to make further requests to other protected services

`env['oauth2_token_data']` - A `Hash` of basic information representing the user associated with the token.  This may include the user's ID, their associated company ID, and any associated OAuth2 scopes.  The actual content will depend on the configuration of the OAuth2 provider service.