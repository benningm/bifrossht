require 'bifrossht/connection/base'
#require 'bifrossht/connection/direct'
require 'bifrossht/connection/exec'
#require 'bifrossht/connection/http_proxy'

module Bifrossht
  class Connection
    class << self
      attr_reader :connections

      def register_connections(connections = [])
        connections.each { |c| register_connection(c) }
      end

      def register_connection(config)
        @connections ||= {}

        klass = build_class_name(config.type)
        @connections[config.name] = klass.new(config)
      end

      def find(target)
        c = match(target)
        return c unless c.nil?

        probe(target)
      end

      def match(target)
        connections.values.select do |c|
          c.match(target)
        end.first
      end

      def probe(target)
        connections.values.reject(&:skip_probe).each do |c|
          Logger.debug("probing #{c.name}...")
          return c if c.probe(target)
        end

        nil
      end

      def connection(hop)
        @connections[hop]
      end

      private

      def build_class_name(type)
        Object.const_get("Bifrossht::Connection::#{type}")
      rescue NameError => e
        raise ParameterError, "Cant load connection: #{e.message}"
      end
    end
  end
end
