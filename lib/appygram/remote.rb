require 'zlib'
require 'cgi'
require 'net/http'
require 'net/https'
require 'digest/md5'

module Appygram
  class Remote
    class << self
      def startup_announce(startup_data)
        #FIXME this is a noop based on an Exceptional behavior Appygram doesn't have
        Appygram.logger.info 'Appygram remote exception forwarding started'
      end

      def error(exception_data)
        url = "/api/exceptions?api_key=#{::Appygram::Config.api_key}"
        call_remote(url, exception_data.to_json)
      end

      def call_remote(url, data)
        config = Appygram::Config
        optional_proxy = Net::HTTP::Proxy(config.http_proxy_host,
                                          config.http_proxy_port,
                                          config.http_proxy_username,
                                          config.http_proxy_password)
        client = optional_proxy.new(config.remote_host, config.remote_port)
        client.open_timeout = config.http_open_timeout
        client.read_timeout = config.http_read_timeout
        client.use_ssl = config.ssl?
        client.verify_mode = OpenSSL::SSL::VERIFY_NONE if config.ssl?
        begin
          response = client.post(url, data)
          case response
            when Net::HTTPSuccess
              Appygram.logger.info( "#{url} - #{response.message}")
              return true
            else
              Appygram.logger.error("#{url} - #{response.code} - #{response.message}")
          end
        rescue Exception => e
          Appygram.logger.error('Problem notifying Appygram about the error')
          Appygram.logger.error(e)
        end
        nil
      end
    end
  end
end
