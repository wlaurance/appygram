$:.unshift File.dirname(__FILE__)

require 'appygram/monkeypatches'
require 'appygram/catcher'
require 'appygram/startup'
require 'appygram/log_factory'
require 'appygram/config'
require 'appygram/application_environment'
require 'appygram/exception_data'
require 'appygram/controller_exception_data'
require 'appygram/rack_exception_data'
require 'appygram/alert_data'
require 'appygram/remote'
require 'appygram/integration/rack'    
require 'appygram/integration/rack_rails'
require 'appygram/integration/alerter'
require 'appygram/version'
require 'appygram/integration/debug_exceptions'

require 'appygram/railtie' if defined?(Rails::Railtie)

module Appygram
  PROTOCOL_VERSION = 5
  CLIENT_NAME = 'getappygram-gem'
  ENVIRONMENT_FILTER = []

  def self.logger
    ::Appygram::LogFactory.logger
  end

  def self.configure(api_key)
    Appygram::Config.api_key = api_key
  end

  def self.handle(exception, name=nil)
    Appygram::Catcher.handle(exception, name)
  end
  
  def self.rescue(name=nil, context=nil, &block)
    begin
      self.context(context) unless context.nil?
      block.call
    rescue Exception => e
      Appygram::Catcher.handle(e,name)
    ensure
      self.clear!
    end
  end

  def self.rescue_and_reraise(name=nil, context=nil, &block)
    begin
      self.context(context) unless context.nil?
      block.call
    rescue Exception => e
      Appygram::Catcher.handle(e,name)
      raise(e)
    ensure
      self.clear!      
    end
  end

  def self.clear!
    Thread.current[:appygram_context] = nil
  end

  def self.context(hash = {})
    Thread.current[:appygram_context] ||= {}
    Thread.current[:appygram_context].merge!(hash)
    self
  end
end
