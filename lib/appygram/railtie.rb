require 'appygram'
require 'rails'

module Appygram
  class Railtie < Rails::Railtie

    initializer "appygram.middleware" do |app|

      config_file = File.join(Rails.root, "/config/appygram.yml")
      Appygram::Config.load config_file if File.exist?(config_file)
      # On Heroku config is loaded via the ENV so no need to load it from the file

      if Appygram::Config.should_send_to_api?
        Appygram.logger.info("Loading Appygram #{Appygram::VERSION} for #{Rails::VERSION::STRING}")
        if defined?(ActionDispatch::DebugExceptions)
          ActionDispatch::DebugExceptions.send(:include,Appygram::DebugExceptions)
        else
          app.config.middleware.use "Rack::RailsAppygram"
        end
      end
    end
  end
end
