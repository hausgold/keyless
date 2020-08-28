# frozen_string_literal: true

module Jwt
  module Authenticated
    # The configuration for the JWT authentication concern.
    class Configuration
      include ActiveSupport::Configurable

      # The authenticator function which must be defined by the user to
      # verify the given JSON Web Token. Here comes all your logic to lookup
      # the related user on your database, the token claim verification
      # and/or the token cryptographic signing. The function must return true
      # or false to indicate the validity of the token.
      #
      #   Jwt::Authenticated.configure do |conf|
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
      # property. On the {Jwt::Authenticated::Jwt} class it has to be
      # a simple hash. The default is here the RS256 algorithm with enabled
      # expiration check, and issuer+audience check when the
      # {jwt_issuer}/{jwt_beholder} are configured accordingly.
      config_accessor(:jwt_options) do
        proc do
          conf = ::Jwt::Authenticated.configuration
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
      # on the {Jwt::Authenticated::Jwt} class it has to be a scalar
      # value. By default we use the
      # {Jwt::Authenticated::RsaPublicKey} class to retrieve the RSA
      # public key.
      config_accessor(:jwt_verification_key) do
        proc { RsaPublicKey.instance.fetch }
      end
    end
  end
end
