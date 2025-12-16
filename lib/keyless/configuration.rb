# frozen_string_literal: true

module Keyless
  # The configuration for the JWT authentication concern.
  class Configuration < ActiveSupport::OrderedOptions
    # Track our configurations settings (+Symbol+ keys) and their defaults as
    # lazy-loaded +Proc+'s values
    class_attribute :defaults,
                    instance_reader: true,
                    instance_writer: false,
                    instance_predicate: false,
                    default: {}

    # Create a new +Configuration+ instance with all settings populated with
    # their respective defaults.
    #
    # @param args [Hash{Symbol => Mixed}] additional settings which
    #   overwrite the defaults
    # @return [Configuration] the new configuration instance
    def initialize(**args)
      super()
      defaults.each { |key, default| self[key] = instance_exec(&default) }
      merge!(**args)
    end

    # A simple DSL method to define new configuration accessors/settings with
    # their defaults. The defaults can be retrieved with
    # +Configuration.defaults+ or +Configuration.new.defaults+.
    #
    # @param name [Symbol, String] the name of the configuration
    #   accessor/setting
    # @param default [Mixed, nil] a non-lazy-loaded static value, serving as a
    #   default value for the setting
    # @param block [Proc] when given, the default value will be lazy-loaded
    #   (result of the Proc)
    def self.config_accessor(name, default = nil, &block)
      # Save the given configuration accessor default value
      defaults[name.to_sym] = block || -> { default }

      # Compile reader/writer methods so we don't have to go through
      # +ActiveSupport::OrderedOptions#method_missing+.
      define_method(name) { self[name] }
      define_method("#{name}=") { |value| self[name] = value }
    end

    # The authenticator function which must be defined by the user to
    # verify the given JSON Web Token. Here comes all your logic to lookup
    # the related user on your database, the token claim verification
    # and/or the token cryptographic signing. The function must return true
    # or false to indicate the validity of the token.
    #
    #   Keyless.configure do |conf|
    #     conf.authenticator = proc do |token|
    #       # Verify the token the way you like.
    #     end
    #   end
    config_accessor(:authenticator) { proc { false } }

    # Whenever you want to use the {RsaPublicKey} class you configure the
    # default URL on the singleton instance, or use the gem configure
    # method and set it up accordingly.  We allow the fetch of the public
    # key from a remote server (HTTP/HTTPS) or from a local file which is
    # accessible by the ruby process.  Specify the URL or the local path
    # here.
    config_accessor(:rsa_public_key_url) { nil }

    # When the remote (HTTP/HTTPS) fetching failed, how many times to retry the
    # operation.
    config_accessor(:rsa_public_key_fetch_retries) { 5 }

    # You can preconfigure the {RsaPublickey} class to enable/disable
    # caching. For a remote public key location it is handy to cache the
    # result for some time to keep the traffic low to this resource server.
    # For a local file you can skip this.
    config_accessor(:rsa_public_key_caching) { false }

    # When you make use of the caching of the {RsaPublicKey} class you can
    # fine tune the expiration time of this cache. The RSA public key from
    # your identity provider should not change this frequent, so a cache
    # for at least one hour is fine. You should not set it lower than one
    # minute. Keep this setting in mind when you change keys. Your
    # infrastructure could be inoperable for this configured time.
    config_accessor(:rsa_public_key_expiration) { 1.hour }

    # The JSON Web Token isser which should be used for verification.
    config_accessor(:jwt_issuer) { nil }

    # The resource server (namely the one which configures this right now)
    # which MUST be present on the JSON Web Token audience claim.
    config_accessor(:jwt_beholder) { nil }

    # You can configure a different JSON Web Token verification option hash
    # if your algorithm differs or you want some extra/different options.
    # Just watch out that you have to pass a proc to this configuration
    # property. On the {Keyless::Jwt} class it has to be
    # a simple hash. The default is here the RS256 algorithm with enabled
    # expiration check, and issuer+audience check when the
    # {jwt_issuer}/{jwt_beholder} are configured accordingly.
    config_accessor(:jwt_options) do
      proc do
        conf = ::Keyless.configuration
        { algorithm: 'RS256',
          exp_leeway: 30.seconds.to_i,
          iss: conf.jwt_issuer,
          verify_iss: !conf.jwt_issuer.nil?,
          aud: conf.jwt_beholder,
          verify_aud: !conf.jwt_beholder.nil?,
          # @TODO: https://github.com/jwt/ruby-jwt/issues/247
          verify_iat: false }
      end
    end

    # You can configure your own verification key on the Jwt wrapper class.
    # This way you can pass your HMAC secret or your ECDSA public key to
    # the JSON Web Token validation method. Here you need to pass a proc,
    # on the {Keyless::Jwt} class it has to be a scalar
    # value. By default we use the
    # {Keyless::RsaPublicKey} class to retrieve the RSA
    # public key.
    config_accessor(:jwt_verification_key) do
      proc { RsaPublicKey.instance.fetch }
    end
  end
end
