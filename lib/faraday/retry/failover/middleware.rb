# frozen_string_literal: true

require 'ipaddr'

require_relative 'endpoint'
require_relative 'ip_validator'
require_relative 'options'

module Faraday
  module Retry
    module Failover
      # This class provides the main implementation for your middleware.
      # Your middleware can implement any of the following methods:
      # * on_request - called when the request is being prepared
      # * on_complete - called when the response is being processed
      #
      # Optionally, you can also override the following methods from Faraday::Middleware
      # * initialize(app, options = {}) - the initializer method
      # * call(env) - the main middleware invocation method.
      #   This already calls on_request and on_complete, so you normally don't need to override it.
      #   You may need to in case you need to "wrap" the request or need more control
      #   (see "retry" middleware: https://github.com/lostisland/faraday/blob/main/lib/faraday/request/retry.rb#L142).
      #   IMPORTANT: Remember to call `@app.call(env)` or `super` to not interrupt the middleware chain!
      class Middleware < Faraday::Middleware
        FAILOVER_ENDPOINTS_ENV_KEY     = :failover_endpoints
        FAILOVER_COUNTER_ENV_KEY       = :failover_counter
        FAILOVER_ORIGINAL_HOST_ENV_KEY = :failover_original_hostname
        FAILOVER_ORIGINAL_PORT_ENV_KEY = :failover_original_port

        def initialize(app, options = nil)
          super(app)
          @options = Faraday::Retry::Failover::Options.from(options)
        end

        # This method will be called when the request is being prepared.
        # You can alter it as you like, accessing things like request_body, request_headers, and more.
        # Refer to Faraday::Env for a list of accessible fields:
        # https://github.com/lostisland/faraday/blob/main/lib/faraday/options/env.rb
        #
        # @param env [Faraday::Env] the environment of the request being processed
        def on_request(env)
          # If we have not already resolved the failover endpoints, do so now
          setup_resolution_env(env) unless env[FAILOVER_ENDPOINTS_ENV_KEY]&.any?

          # If there is already a response associated with the request, it means that the request failed and we're retrying it.
          # Increment the failover counter so we push on to the next endpoint
          env[FAILOVER_COUNTER_ENV_KEY] += 1 unless env[:response].nil?

          # Assign the next Failover endpoint to the request
          setup_next_failover_endpoint(env)
        end

        private

        def setup_next_failover_endpoint(env)
          next_failover_endpoint = env[FAILOVER_ENDPOINTS_ENV_KEY][env[FAILOVER_COUNTER_ENV_KEY] % env[FAILOVER_ENDPOINTS_ENV_KEY].size]

          if next_failover_endpoint.request_host
            env[:request_headers] ||= {}
            env[:request_headers]['Host'] = next_failover_endpoint.request_host
          end

          env[:url].hostname = next_failover_endpoint.ip_addr
        end

        def setup_resolution_env(env)
          env[FAILOVER_ORIGINAL_HOST_ENV_KEY] = env[:url].hostname
          env[FAILOVER_ORIGINAL_PORT_ENV_KEY] = env[:url].port
          env[FAILOVER_COUNTER_ENV_KEY]       = 0
          env[FAILOVER_ENDPOINTS_ENV_KEY]     = resolv_endpoints(env)
        end

        def resolv_endpoints(env)
          host_list = if env[FAILOVER_ORIGINAL_HOST_ENV_KEY]
                        [[env[FAILOVER_ORIGINAL_HOST_ENV_KEY], env[FAILOVER_ORIGINAL_PORT_ENV_KEY]]] + @options.hosts(refresh: true)
                      else
                        @options.hosts
                      end

          host_list.map { |host, port| Endpoint.from_host_and_port(host, port) }.flatten
        end
      end
    end
  end
end
