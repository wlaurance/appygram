module Exceptional
  class Config
    class << self
      DEFAULTS = {
        :ssl_enabled => false,
        :remote_host_http => 'api.getexceptional.com',
        :remote_port_http => 80,
        :remote_host_https => 'getexceptional.appspot.com',
        :remote_port_https => 443,
        :http_open_timeout => 2,
        :http_read_timeout => 4,
        :disabled_by_default => %w(development test)
      }

      attr_accessor :api_key, :application_root
      attr_accessor :http_proxy_host, :http_proxy_port, :http_proxy_username, :http_proxy_password
      attr_writer :ssl_enabled

      def load(application_root, environment, config_file=nil)
        @application_root = application_root
        @environment = environment
        if (config_file && File.file?(config_file))
          begin
            config = YAML::load(File.open(config_file))
            env_config = config[environment] || {}

            @api_key = config['api-key'] || env_config['api-key']

            @http_proxy_host = config['http-proxy-host']
            @http_proxy_port = config['http-proxy-port']
            @http_proxy_username = config['http-proxy-username']
            @http_proxy_password = config['http-proxy-password']
            @http_open_timeout = config['http-open-timeout']
            @http_read_timeout = config['http-read-timeout'] 

            @ssl_enabled = config['ssl'] || env_config['ssl']
            @enabled = env_config['enabled']
            @remote_port = config['remote-port'].to_i unless config['remote-port'].nil?
            @remote_host = config['remote-host'] unless config['remote-host'].nil?
          rescue Exception => e
            raise ConfigurationException.new("Unable to load configuration #{config_file} for environment #{environment} : #{e.message}")
          end
        end
        @api_key = ENV['EXCEPTIONAL_API_KEY'] unless ENV['EXCEPTIONAL_API_KEY'].nil?
      end

      def enabled?
        @enabled ||= DEFAULTS[:disabled_by_default].include?(@environment) ? false : true
      end

      def application_root
        @application_root ||= File.expand_path(File.dirname(__FILE__) + '/../../../../../')
      end

      def ssl_enabled?
        @ssl_enabled ||= DEFAULTS[:ssl_enabled]
      end

      def remote_host
        @remote_host ||= ssl_enabled? ? DEFAULTS[:remote_host_https] : DEFAULTS[:remote_host_http]
      end

      def remote_port
        @remote_port ||= ssl_enabled? ? DEFAULTS[:remote_port_https] : DEFAULTS[:remote_port_http]
      end

      def reset
        @ssl_enabled = @remote_host = @remote_port = @api_key = nil
      end

      def http_open_timeout
        @http_open_timeout ||= DEFAULTS[:http_open_timeout]
      end

      def http_read_timeout
        @http_read_timeout ||= DEFAULTS[:http_read_timeout]
      end
    end
  end
end