require 'bifrossht/host_filter/base'
require 'bifrossht/host_filter/search_domain'

module Bifrossht
  class HostFilter
    class << self
      attr_reader :filters

      def register_filters(filters = [])
        filters.each { |f| register_filter(f) }
      end

      def register_filter(config)
        @filters ||= []

        klass = build_class_name(config.type)
        @filters << klass.new(config)
      end

      def apply(target)
        filters.each do |filter|
          next unless filter.match(target.host)

          new_host = filter.apply(target.host)
          target.rewrite(new_host)
        end
      end

      private

      def build_class_name(type)
        Object.const_get("Bifrossht::HostFilter::#{type}")
      rescue NameError => e
        raise ParameterError, "Cant load host_filter: #{e.message}"
      end
    end
  end
end
