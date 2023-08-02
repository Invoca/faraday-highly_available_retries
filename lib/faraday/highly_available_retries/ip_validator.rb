# frozen_string_literal: true

require 'ipaddr'

module Faraday
  module HighlyAvailableRetries
    class IpValidator
      class << self
        def ip_addr?(addr)
          IPAddr.new(addr)
          true
        rescue
          false
        end
      end
    end
  end
end
