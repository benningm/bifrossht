module Bifrossht
  class Config
    class HostFilter < Config::Element
      def initialize(options = {})
        super

        validate_presence 'type', 'domains'
        validate_type 'type', String
        validate_type 'domains', Array
        validate_type 'prefixes', Array
      end

      def type
        @options['type']
      end

      def domains
        @options['domains'] || []
      end

      def prefixes
        @options['prefixes'] || []
      end
    end
  end
end
