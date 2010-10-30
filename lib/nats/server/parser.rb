
require 'optparse'
require 'yaml'

module NATS
  class Server

    class << self
      def parser
        @parser ||= OptionParser.new do |opts|
          opts.banner = "Usage: nats [options]"

          opts.separator ""
          opts.separator "Server options:"

          opts.on("-a", "--addr HOST", "bind to HOST address " +
                                       "(default: #{@options[:addr]})")                 { |host| @options[:address] = host }
          opts.on("-p", "--port PORT", "use PORT (default: #{@options[:port]})")        { |port| @options[:port] = port.to_i }
        
          opts.on("-d", "--daemonize", "Run daemonized in the background")              { @options[:daemonize] = true }
          opts.on("-l", "--log FILE", "File to redirect output " +                      
                                      "(default: #{@options[:log_file]})")              { |file| @options[:log_file] = file }
          opts.on("-T", "--logtime", "Timestamp log entries")                           { @options[:log_time] = true }

          opts.on("-P", "--pid FILE", "File to store PID " +                            
                                      "(default: #{@options[:pid_file]})")              { |file| @options[:pid_file] = file }

          opts.on("-C", "--config FILE", "Configuration File " +                            
                                      "(default: #{@options[:config_file]})")           { |file| @options[:config_file] = file }

          opts.separator ""
          opts.separator "Authorization options: (Should be done in config file for production)"

          opts.on("--user user", "User required for connections")                       { |user| @options[:user] = user }

          opts.on("--password password", "Password required for connections")          { |pass| @options[:user] = pass }

          opts.separator ""
          opts.separator "Common options:"

          opts.on_tail("-h", "--help", "Show this message")                             { puts opts; exit }
          opts.on_tail('-v', '--version', "Show version")                               { puts NATS::Server.version; exit }
          opts.on_tail("-D", "--debug", "Set debugging on")                             { @options[:debug] = true }
          opts.on_tail("-V", "--trace", "Set tracing on of raw protocol")               { @options[:trace] = true }
        end
      end

      def read_config_file
        return unless config_file = @options[:config_file]
        config = File.open(config_file) { |f| YAML.load(f) }
        # Command lines args, parsed first, will override these.
        [:addr, :port, :log_file, :pid_file, :user, :pass, :log_time, :debug].each do |p|
          c = config[p.to_s]
          @options[p] = c if c and not @options[p]
        end
        rescue => e
          log "Could not read configuration file:  #{e}"
          exit
      end
    end

  end
end
