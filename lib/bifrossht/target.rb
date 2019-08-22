require 'ipaddr'
require 'resolv'

module Bifrossht
  class Target
    attr_reader :entries
    attr_reader :port

    def initialize(host, port)
      @entries = [host]
      @port = port.to_i
    end

    def rewrite(new)
      return if new == host

      @entries.push(new)
    end

    def orig_host
      @entries.first
    end

    def host
      @entries.last
    end

    def to_s
      host
    end

    def ip
      @ip ||= IPAddr.new host
    rescue IPAddr::InvalidAddressError
      nil
    end

    def ip?
      !ip.nil?
    end

    def resolved_ip
      @resolved_ip ||= resolve_address
    end

    def resolvable?
      !resolved_ip.nil?
    end

    private

    def resolve_address
      return ip if ip?

      record = Resolv.getaddress(host)
      return nil unless record

      IPAddr.new(record)
    rescue Resolv::ResolvError
      nil
    rescue IPAddr::InvalidAddressError
      nil
    end
  end
end
