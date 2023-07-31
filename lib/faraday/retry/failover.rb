# frozen_string_literal: true

require 'faraday/retry'

require_relative 'failover/middleware'
require_relative 'failover/version'

module Faraday
  module Retry
    # This will be your middleware main module, though the actual middleware implementation will go
    # into Faraday::Retry::Failover::Middleware for the correct namespacing.
    module Failover
      # Faraday allows you to register your middleware for easier configuration.
      # This step is totally optional, but it basically allows users to use a
      # custom symbol (in this case, `:failover`), to use your middleware in their connections.
      # After calling this line, the following are both valid ways to set the middleware in a connection:
      # * conn.use Faraday::Retry::Failover::Middleware
      # * conn.use :failover
      # Without this line, only the former method is valid.
      # Faraday::Middleware.register_middleware(retry_with_failover: Faraday::Retry::Failover::Middleware)

      # Alternatively, you can register your middleware under Faraday::Request or Faraday::Response.
      # This will allow to load your middleware using the `request` or `response` methods respectively.
      #
      # Load middleware with conn.request :failover
      Faraday::Request.register_middleware(retry_with_failover: Faraday::Retry::Failover::Middleware)
      #
      # Load middleware with conn.response :failover
      # Faraday::Response.register_middleware(failover: Faraday::Retry::Failover::Middleware)
    end
  end
end
