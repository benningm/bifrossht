module Bifrossht
  class Connection
    class Base
      attr_accessor :config

      def initialize(config)
        @config = config
      end

      def name
        config.name
      end

      def probe(_target)
        raise 'not implemented'
      end

      def connect(_target)
        raise 'not implemented'
      end

      def skip_probe
        config.skip_probe
      end

      def match(target)
        host_matches = config.match.select do |re|
          re.match(target.host)
        end
        return true if host_matches.any?

        if target.resolvable?
          addr_matches = config.match_addr.select do |net|
            net.include?(target.resolved_ip)
          end
          return true if addr_matches.any?
        end

        false
      end
    end
  end
end
