# frozen_string_literal: true

require 'zeitwerk'
require 'logger'
require 'active_support'
require 'active_support/concern'
require 'active_support/configurable'
require 'active_support/cache'
require 'active_support/core_ext/hash'
require 'active_support/time'
require 'active_support/time_with_zone'
require 'jwt'
require 'recursive-open-struct'
require 'singleton'
require 'openssl'
require 'httparty'

# The JWT authentication concern.
module Keyless
  # Setup a Zeitwerk autoloader instance and configure it
  loader = Zeitwerk::Loader.for_gem

  # Finish the auto loader configuration
  loader.setup

  # Load standalone code
  require 'keyless/version'

  # Make sure to eager load all constants
  loader.eager_load

  class << self
    attr_writer :configuration

    # Retrieve the current configuration object.
    #
    # @return [Configuration]
    def configuration
      @configuration ||= Configuration.new
    end

    # Configure the concern by providing a block which takes
    # care of this task. Example:
    #
    #   Keyless.configure do |conf|
    #     # conf.xyz = [..]
    #   end
    def configure
      yield(configuration)
    end

    # Reset the current configuration with the default one.
    def reset_configuration!
      self.configuration = Configuration.new
    end
  end
end
