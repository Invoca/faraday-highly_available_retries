# frozen_string_literal: true

require_relative 'highly_available_retries/middleware'
require_relative 'highly_available_retries/version'

module Faraday
  # This will be your middleware main module, though the actual middleware implementation will go
  # into Faraday::HighlyAvailableRetries::Middleware for the correct namespacing.
  module HighlyAvailableRetries
    # Faraday allows you to register your middleware for easier configuration.
    # This step is totally optional, but it basically allows users to use a
    # custom symbol (in this case, `:highly_available_retries`), to use your middleware in their connections.
    # After calling this line, the following are both valid ways to set the middleware in a connection:
    # * conn.use Faraday::HighlyAvailableRetries::Middleware
    # * conn.use :highly_available_retries
    # Without this line, only the former method is valid.
    # Faraday::Middleware.register_middleware(highly_available_retries: Faraday::HighlyAvailableRetries::Middleware)

    # Alternatively, you can register your middleware under Faraday::Request or Faraday::Response.
    # This will allow to load your middleware using the `request` or `response` methods respectively.
    #
    # Load middleware with conn.request :failover
    Faraday::Request.register_middleware(highly_available_retries: Faraday::HighlyAvailableRetries::Middleware)
    #
    # Load middleware with conn.response :highly_available_retries
    # Faraday::Response.register_middleware(highly_available_retries: Faraday::HighlyAvailableRetries::Middleware)
  end
end
