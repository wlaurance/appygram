module Appygram
  class Alert <StandardError;
  end

  module Integration
    def self.alert(msg, env={})
      return Appygram::Remote.error(Appygram::AlertData.new(Alert.new(msg), "Alert"))
    end
  end
end

