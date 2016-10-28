require 'promise'
require 'eventmachine'
require 'pry'

module NGBackup
  class Prom < promise
    def defer
      EM.next_tick { yield }
    end
  end

  class Backup
    def initialize
      # We need a few params

      # Hostname
      if File.exists? '/etc/hostname'
        @hostname = File.read('/etc/hostname').chomp.strip
      else
        @hostname = `hostname`.chomp
      end

      @basename = 'blah'
      @stamp = Time.new

      @scripts = {}

      %w[
        pre_exec
        pipe_exec_stdout
        upload_exec
        post_exec_failure
        post_exec_success
        post_exec_always
      ].each do |section|
        @scripts[section] = File.expand_path("examples/exec_scripts/#{section}.sh")
      end

      @fullname = "backup_#{@hostname}_#{@basename}_#{@stamp.strftime('%Y%m%d_%H%M')}"
      @file_ext = "tar.gz"

      @tmpdir = "/tmp/ngbackup"
      @max_tmpfile_num = 3

    end

    def run
      EM.run do
        @logger = NGBackup::Logger.new
        myexec = EM.popen(@pre_exec, MyExec, logger: @logger, cb: Proc.new { puts "im ze callbak" ; EM.stop })
      end
      puts "log: #{@logger}"
    end

    def run_if_error
      # Push
    end
  end

  class Logger
    def initialize
      @data = []
    end

    def write(data)
      @data << "#{Time.new.to_i} #{data}"
    end

    def to_s
      @data.join("\n")
    end
  end

  # Extra modules : for the backup. I'll use weird names
  module MyExec
    def initialize(**params)
      params.each do |k,v|
        k = "@#{k.to_s}".to_sym if k.to_s[0] != '@'
        instance_variable_set(k,v)
      end
    end

    def receive_data(data)
      puts "data: #{data}"
      @logger.write(data) if @logger
    end

    def unbind
      @cb.call if @cb
    end
  end

  module PipeReadAndSplit
    # This just sets internal variables from key/value
    def initialize(**params)
      params.each do |k,v|
        k = "@#{k.to_s}".to_sym if k.to_s[0] != '@'
        instance_variable_set(k,v)
      end
    end

    def receive_data(data)
      puts "Got data: #{data}"
    end

    def unbind
      puts "end!"
      
    end
  end
end
