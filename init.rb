require 'appygram'

# If old plugin still installed then we don't want to install this one.
# In production environments we should continue to work as before, but in development/test we should
# advise how to correct the problem and exit
if (defined?(Appygram::VERSION::STRING) rescue nil) && %w(development test).include?(RAILS_ENV)
  message = %Q(
  ***********************************************************************
  You seem to still have an old version of the Appygram plugin installed.
  Remove it from /vendor/plugins and try again.
  ***********************************************************************
  )
  puts message
  exit -1
else
  begin

    if (Rails::VERSION::MAJOR < 3)    
      Appygram::Config.load(File.join(RAILS_ROOT, "/config/Appygram.yml"))
      if Appygram::Config.should_send_to_api?
        Appygram.logger.info("Loading Appygram #{Appygram::VERSION} for #{Rails::VERSION::STRING}")      
        require File.join('Appygram', 'integration', 'rails')    
        require File.join('Appygram', 'integration', 'dj') if defined?(Delayed::Job)
      end
    else
      Appygram::Config.load(File.join(Rails.root, "/config/Appygram.yml"))
      
      if Appygram::Config.should_send_to_api?
        Appygram.logger.info("Loading Appygram #{Appygram::VERSION} for #{Rails::VERSION::STRING}")      
        Rails.configuration.middleware.use "Rack::RailsAppygram"
        require File.join('Appygram', 'integration', 'dj') if defined?(Delayed::Job)
      end      
    end
  rescue => e
    STDERR.puts "Problem starting Appygram Plugin. Your app will run as normal. #{e.message}"
    Appygram.logger.error(e.message)
    Appygram.logger.error(e.backtrace)
  end
end
