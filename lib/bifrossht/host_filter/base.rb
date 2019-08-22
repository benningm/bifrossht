module Bifrossht
  class HostFilter
    class Base
      attr_accessor :config

      def initialize(config)
        @config = config
      end

      def match(_host)
        false
      end

      def apply(host)
        host
      end
    end
  end
end
