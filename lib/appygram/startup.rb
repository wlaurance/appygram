module Appygram
  class StartupException < StandardError;
  end
  class Startup
    class << self
      def announce
        if Config.api_key.blank?
          raise StartupException, 'API Key must be configured (/config/appygram.yml)'
        end
        Remote.startup_announce(::Appygram::ApplicationEnvironment.to_hash('rails'))
      end
    end
  end
end
