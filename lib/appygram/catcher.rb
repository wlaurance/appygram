module Appygram
  class Catcher
    class << self
      def handle_with_controller(exception, controller=nil, request=nil)
        if Config.should_send_to_api?
          data = ControllerExceptionData.new(exception, controller, request)
          Remote.error(data)
        else
          raise exception
        end
      end
      
      # unspeced
      def handle_with_rack(exception, environment, request) 
        if Config.should_send_to_api?
          data = RackExceptionData.new(exception, environment, request)
          Remote.error(data)
        else
          raise exception
        end
      end

      # unspeced
      def handle(exception, name=nil)
        if Config.should_send_to_api?
          data = ExceptionData.new(exception, name)
          Remote.error(data)
        else
          raise exception
        end
      end
    end
  end
end
