require 'resolv'

module Bifrossht
  class HostFilter
    class SearchDomain < Base
      def match(host)
        host !~ /\./
      end

      def apply(host)
        prefixes = [''] + config.prefixes

        config.domains.each do |domain|
          prefixes.each do |prefix|
            record = "#{prefix}#{host}.#{domain}"

            begin
              address = Resolv.getaddress record
            rescue Resolv::ResolvError => e
              Logger.debug "SearchDomain: #{e.message}"
            end

            unless address.nil?
              Logger.debug "SearchDomain: using #{record}"
              return record
            end
          end
        end

        host
      end
    end
  end
end
