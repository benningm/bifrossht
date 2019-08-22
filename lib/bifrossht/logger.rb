require 'logger'
require 'forwardable'

module Bifrossht
  class Logger
    class << self
      extend Forwardable

      def_delegators :@logger, :debug, :info, :warn, :error, :fatal

      def log_level(level = 'warn')
        mylevel = case level
                  when 'debug' then ::Logger::DEBUG
                  when 'info' then ::Logger::INFO
                  when 'warn' then ::Logger::WARN
                  when 'error' then ::Logger::ERROR
                  when 'fatal' then ::Logger::FATAL
                  else
                    raise "Unknown log-level #{level}"
                  end

        logger.level = mylevel
      end

      def logger
        return @logger unless @logger.nil?

        @logger = ::Logger.new(STDERR)
        @logger.level = ::Logger::INFO
        @logger.formatter = proc do |severity, _datetime, _progname, msg|
          if severity == 'INFO'
            "#{msg}\n"
          else
            "#{severity}: #{msg}\n"
          end
        end

        @logger
      end
    end
  end
end
