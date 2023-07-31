# frozen_string_literal: true

module Faraday
  module Retry
    module Failover
      # Options contains the configurable parameters for the Failover middleware.
      class Options < Faraday::Options.new(:hosts, :default_port)
        DEFAULT_PORT = 80

        def hosts(refresh: false)
          if refresh
            @hosts = nil
          end

          @hosts ||= load_host_list
        end

        def default_port
          self[:default_port] ||= DEFAULT_PORT
        end

        private

        def load_host_list
          hosts = self[:hosts] ||= []
          host_list = case hosts
                      when Proc
                        hosts.call
                      when Array
                        hosts
                      else
                        [hosts]
                      end
          host_list.map { |host| host_to_hostname_and_port(host) }
        end

        def host_to_hostname_and_port(host)
          hostname, port = host.split(':', 2)
          [hostname, port ? port.to_i : default_port]
        end
      end
    end
  end
end
