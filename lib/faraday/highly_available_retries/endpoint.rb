# frozen_string_literal: true

require 'ipaddr'

require_relative 'ip_validator'

module Faraday
  module HighlyAvailableRetries
    class Endpoint
      class DNSResolutionError < StandardError; end

      include Comparable

      class << self
        def from_host_and_port(host, port)
          host_ips = Socket.getaddrinfo(host, nil, Socket::AF_INET, Socket::SOCK_STREAM) or raise DNSResolutionError, "getaddrinfo(#{host}) failed"
          host_ips.any? or raise DNSResolutionError, "No IP addrs returned from #{host}"
          host_ips.map { |host_ip| new(host_ip[3], port, hostname: host) }
        end
      end

      attr_reader :ip_addr, :port, :request_host

      def initialize(ip_addr, port, hostname: nil)
        IpValidator.ip_addr?(ip_addr) or raise ArgumentError, "ip_addr must be a valid IP address but received #{ip_addr.inspect}"

        @ip_addr      = ip_addr
        @port         = port
        @request_host = if hostname && !IpValidator.ip_addr?(hostname)
                          "#{hostname}:#{port}"
                        end
      end

      def <=>(other)
        ip_addr <=> other.ip_addr &&
          port <=> other.port &&
          request_host <=> other.request_host
      end
    end
  end
end
