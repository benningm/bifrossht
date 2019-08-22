module Bifrossht
  class Connection
    class Exec < Base
      def probe(target)
        cmd = command(target)
        Logger.debug("probing command: #{cmd}")
        in_r, in_w = IO.pipe
        io = IO.popen(['sh', '-c', cmd, in: in_w, err: '/dev/null'])
        in_w.close
        ready = IO.select([io], nil, nil, timeout)
        if ready
          banner = io.readline
        else
          Logger.debug('probe timed out!')
        end
        Process.kill('TERM', io.pid)
        in_r.close
        io.close

        return true if banner =~ /^SSH-/

        false
      rescue EOFError
        false
      end

      def connect(target)
        cmd = command(target)
        Logger.debug("executing: #{cmd}")
        exec cmd
      end

      private

      def command(target)
        command_pattern.gsub('%h', target.host).gsub('%p', target.port.to_s)
      end

      def command_pattern
        config.parameters['command'] || 'ssh -W %h:%p'
      end

      def timeout
        (config.parameters['timeout'] || 3).to_i
      end
    end
  end
end
