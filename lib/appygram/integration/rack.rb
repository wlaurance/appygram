require 'rubygems'
require 'rack'

module Rack
  class Appygram

    def initialize(app, api_key = nil)
      @app = app
      if api_key.nil?
        appygram_config = "config/appygram.yml"
        ::Appygram::Config.load(appygram_config)
      else
        ::Appygram.configure(api_key)
        ::Appygram::Config.enabled = true
        ::Appygram.logger.info "Enabling Appygram for Rack"
      end
    end

    def call(env)
      begin
        status, headers, body =  @app.call(env)
      rescue Exception => e
        ::Appygram::Catcher.handle_with_rack(e,env, Rack::Request.new(env))
        raise(e)
      end
    end
  end
end
