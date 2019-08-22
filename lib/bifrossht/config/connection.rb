module Bifrossht
  class Config
    class Connection < Config::Element
      def initialize(options = {})
        super

        validate_presence 'type', 'name'
        validate_type 'type', String
        validate_type 'name', String
        validate_boolean 'skip_probe'
        validate_type 'parameters', Hash
        validate_type 'match', Array
        validate_type 'match_addr', Array
      end

      def type
        @options['type']
      end

      def name
        @options['name']
      end

      def skip_probe
        @options['skip_probe'] || false
      end

      def parameters
        @options['parameters'] || {}
      end

      def match
        return [] if @options['match'].nil?

        @options['match'].map { |re| Regexp.new re }
      end

      def match_addr
        return [] if @options['match_addr'].nil?

        @options['match_addr'].map { |ip| IPAddr.new ip }
      end
    end
  end
end
