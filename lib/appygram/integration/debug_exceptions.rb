module Appygram
  module DebugExceptions

    def self.included(base)
      base.send(:alias_method_chain,:render_exception,:appygram)
    end

    def render_exception_with_appygram(env,exception)
      ::Appygram::Catcher.handle_with_controller(exception,
                                                    env['action_controller.instance'],
                                                    Rack::Request.new(env))
      render_exception_without_appygram(env,exception)
    end

  end
end
