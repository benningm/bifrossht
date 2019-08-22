require 'bifrossht/config/element'
require 'bifrossht/config/host_filter'
require 'bifrossht/config/connection'

require 'yaml'

module Bifrossht
  class Config
    class << self
      attr_reader :config

      def load_config(path)
        @config = YAML.load_file(File.expand_path(path)) || {}
      rescue Errno::ENOENT => e
        raise ParameterError, "Configuration file: #{e.message}"
      end

      def host_filters
        @host_filters ||= build_subconfig('host_filters', Config::HostFilter)
      end

      def connections
        @connections ||= build_subconfig('connections', Config::Connection)
      end

      private

      def build_subconfig(key, klass)
        return [] unless @config.key?(key)

        params = @config[key]

        unless params.is_a? Array
          raise ParameterError, "#{key} must be an array"
        end

        params.map { |c| klass.new(c) }
      end
    end
  end
end
