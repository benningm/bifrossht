require 'gli'

require 'bifrossht/version.rb'
require 'bifrossht/errors.rb'
require 'bifrossht/logger.rb'
require 'bifrossht/config.rb'
require 'bifrossht/host_filter.rb'
require 'bifrossht/connection.rb'
require 'bifrossht/target.rb'

module Bifrossht
  class App
    extend GLI::App

    program_desc 'SSH auto-routing proxy command'

    version Bifrossht::VERSION

    subcommand_option_handling :normal
    arguments :strict

    desc 'configuration file'
    default_value '~/.bifrossht.yml'
    arg_name 'path'
    flag %i[c config]

    desc 'log level'
    default_value 'info'
    arg_name 'log_level'
    flag %i[l log_level]

    desc 'connect to an target'
    arg 'host'
    command :connect do |c|
      c.flag %i[p port], default_value: '22'
      c.action do |_global_options, options, args|
        target = Target.new(args[0], options[:port])

        HostFilter.apply(target)
        hop = Connection.find(target)
        raise ApplicationError, 'no suitable hop found' unless hop

        Logger.info("Connecting #{target.host} using #{hop.name}...")
        hop.connect(target)
      end
    end

    pre do |global, _command, _options, _args|
      Logger.log_level(global[:l])
      Config.load_config(global[:c])
      HostFilter.register_filters(Config.host_filters)
      Connection.register_connections(Config.connections)
      true
    end

    post do |global, command, options, args|
      # empty
    end

    on_error do |e|
      raise e unless e.is_a? Bifrossht::Error

      Logger.error(e.message)
      false
    end
  end
end
