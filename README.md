![jwt-authenticated](doc/assets/project.svg)

[![Build Status](https://travis-ci.com/hausgold/jwt-authenticated.svg?branch=master)](https://travis-ci.com/hausgold/jwt-authenticated)
[![Gem Version](https://badge.fury.io/rb/jwt-authenticated.svg)](https://badge.fury.io/rb/jwt-authenticated)
[![API docs](https://img.shields.io/badge/docs-API-blue.svg)](https://www.rubydoc.info/gems/jwt-authenticated)

This gem is dedicated to easily integrate a JWT authentication to your
ruby application. The real authentication
functionality must be provided by the user and this makes this gem highy
flexible on the JWT verification level.

- [Installation](#installation)
- [Configuration](#configuration)
  - [Authenticator](#authenticator)
  - [RSA public key helper](#rsa-public-key-helper)
    - [RSA public key location (URL)](#rsa-public-key-location-url)
    - [RSA public key caching](#rsa-public-key-caching)
    - [RSA public key cache expiration](#rsa-public-key-cache-expiration)
  - [JWT instance helper](#jwt-instance-helper)
    - [Issuer verification](#issuer-verification)
    - [Beholder (audience) verification](#beholder-audience-verification)
    - [Custom JWT verification options](#custom-jwt-verification-options)
    - [Custom JWT verification key](#custom-jwt-verification-key)
  - [Full RSA256 example](#full-rsa256-example)
- [Development](#development)
- [Contributing](#contributing)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jwt-authenticated'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install jwt-authenticated
```

## Configuration

This gem is quite customizable and flexible to fulfill your needs. You can make
use of some parts and leave other if you do not care about them. We are not
going to force the way how to verify JWT or work with them. Here comes a
overview of the configurations you can do.

### Authenticator

The authenticator function which must be defined by the user to verify the
given JSON Web Token. Here comes all your logic to lookup the related user on
your database, the token claim verification and/or the token cryptographic
signing. The function must return true or false to indicate the validity of the
token.

```ruby
Jwt::Authenticated.configure do |conf|
  conf.authenticator = proc do |token|
    # Verify the token the way you like. (true, false)
  end
end
```

### RSA public key helper

We provide a straightforward solution to deal with the provision of RSA public
keys.  Somethimes you want to distribute them by file to each machine and have
a local access, and somethimes you provide an endpoint on your identity
provider to fetch the RSA public key via HTTP/HTTPS.  The `RsaPublicKey` class
helps you to fulfill this task easily.

**Heads up!** You can skip this if you do not care about RSA verification or
have your own mechanism.

```ruby
# Get your public key, by using the global configuration
public_key = Jwt::Authenticated::RsaPublicKey.fetch
# => OpenSSL::PKey::RSA

# Using a local configuration
fetcher = Jwt::Authenticated::RsaPublicKey.instance
fetcher.url = 'https://your.identity.provider/rsa_public_key'
public_key = fetcher.fetch
# => OpenSSL::PKey::RSA
```

The following examples show you how to configure the
`Jwt::Authenticated::RsaPublicKey` class the global way. This is useful
for a shared initializer place.

#### RSA public key location (URL)

Whenever you want to use the `RsaPublicKey` class you configure the default URL
on the singleton instance, or use the gem configure method and set it up
accordingly.  We allow the fetch of the public key from a remote server
(HTTP/HTTPS) or from a local file which is accessible by the ruby process.
Specify the URL or the local path here. Not specified by default.

```ruby
Jwt::Authenticated.configure do |conf|
  # Local file
  conf.rsa_public_key_url = '/tmp/jwt_rsa.pub'
  # Remote URL
  conf.rsa_public_key_url = 'https://your.identity.provider/rsa_public_key'
end
```

#### RSA public key caching

You can configure the `RsaPublickey` class to enable/disable caching. For a
remote public key location it is handy to cache the result for some time to
keep the traffic low to the resource server.  For a local file you can skip
this. Disabled by default.

```ruby
Jwt::Authenticated.configure do |conf|
  conf.rsa_public_key_caching = true
end
```

#### RSA public key cache expiration

When you make use of the cache of the `RsaPublicKey` class you can fine tune
the expiration time. The RSA public key from your identity
provider should not change this frequent, so a cache for at least one hour is
fine. You should not set it lower than one minute. Keep this setting in mind
when you change keys. Your infrastructure could be inoperable for this
configured time.  One hour by default.

```ruby
Jwt::Authenticated.configure do |conf|
  conf.rsa_public_key_expiration = 1.hour
end
```

### JWT instance helper

We ship a little wrapper class to ease the validation of JSON Web Tokens with
the help of the great [ruby-jwt](https://github.com/jwt/ruby-jwt) library. This
wrapper class provides some helpers like `#access_token?`, `#refresh_token?` or
`#expires_at` which returns a ActiveSupport time-zoned representation of the
token expiration timestamp. It is initially opinionated to RSA verification,
but can be tuned to verify HMAC or ECDSA signed tokens. It integrated well with
the `RsaPublicKey` fetcher class. (by default)

**Heads up!** You can skip this if you have your own JWT verification mechanism.

```ruby
# A raw JWT (no signing, payload: {test: true})
raw_token = 'eyJ0eXAiOiJKV1QifQ.eyJ0ZXN0Ijp0cnVlfQ.'

# Parse the raw token and create a instance of it
token = Jwt::Authenticated::Jwt.new(raw_token)

# Access the payload easily (recursive-open-struct)
token.payload.test
# => true

# Validate the token (we assume you configured the verification key, an/or
# you own custom JWT verification options here)
token.valid?
# => true
```

The following examples show you how to configure the
`Jwt::Authenticated::Jwt` class the global way. This is useful for a
shared initializer place.

#### Issuer verification

The JSON Web Token issuer which should be used for verification. When `nil` we
also turn off the verification by default. (See the default JWT options)

```ruby
Jwt::Authenticated.configure do |conf|
  conf.jwt_issuer = 'your-identity-provider'
end
```

#### Beholder (audience) verification

The resource server (namely the one which configures this right now)
which MUST be present on the JSON Web Token audience claim. When `nil` we
also turn off the verification by default. (See the default JWT options)

```ruby
Jwt::Authenticated.configure do |conf|
  conf.jwt_beholder = 'your-resource-server'
end
```

#### Custom JWT verification options

You can configure a different JSON Web Token verification option hash if your
algorithm differs or you want some extra/different options.  Just watch out
that you have to pass a proc to this configuration property. On the
`Jwt::Authenticated::Jwt` class it has to be a simple hash. The default
is here the `RS256` algorithm with enabled expiration check, and issuer+audience
check when the `jwt_issuer` / `jwt_beholder` are configured accordingly.

```ruby
Jwt::Authenticated.configure do |conf|
  conf.jwt_options = proc do
    # See: https://github.com/jwt/ruby-jwt
    { algorithm: 'HS256' }
  end
end
```

#### Custom JWT verification key

You can configure your own verification key on the `Jwt` wrapper class.  This
way you can pass your HMAC secret or your ECDSA public key to the JSON Web
Token validation method. Here you need to pass a proc, on the
`Jwt::Authenticated::Jwt` class it has to be a scalar value. By default
we use the `RsaPublicKey` class to retrieve the RSA public key.

```ruby
Jwt::Authenticated.configure do |conf|
  conf.jwt_verification_key = proc do
    # Retrieve your verification key (RSA, ECDSA, HMAC secret)
    # the way you like, and pass it back here.
  end
end
```

### Full RSA256 example

Here comes a full example of the opinionated `RSA256` algorithm usage with a
remote RSA public key location, enabled caching and a full token payload
verification.

```ruby
# On an initializer ..
Jwt::Authenticated.configure do |conf|
  # The remote RSA public key location and enabled caching to limit the
  # traffic on the remote server.
  conf.rsa_public_key_url = 'https://your.identity.provider/rsa_public_key'
  conf.rsa_public_key_caching = true
  conf.rsa_public_key_expiration = 10.minutes

  # Configure the JWT wrapper.
  conf.jwt_issuer = 'The Identity Provider'
  conf.jwt_beholder = 'example-api'

  # Custom verification logic.
  conf.authenticator = proc do |token|
    # Parse and instantiate a JWT verification instance
    jwt = Jwt::Authenticated::Jwt.new(token)

    # We just allow valid access tokens
    jwt.access_token? && jwt.valid?
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bundle exec rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/hausgold/jwt-authenticated.
