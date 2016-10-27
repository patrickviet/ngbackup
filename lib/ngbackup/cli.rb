
module NGBackup
  class CLI
    def run!
      NGBackup::Backup.new.run
      #if ARGV.first == 'run'
        
      #end
    end

    def run_all
      #Conf.
    end

    def run_backup

    end
  end
end
