# frozen_string_literal: true

module DSLCompose
  class ClassCoerce
    class UnexpectedClassNameError < StandardError
    end

    def initialize class_name
      unless class_name.is_a? String
        raise UnexpectedClassNameError, "expected `#{class_name}` to be a String"
      end

      @class_name = class_name
    end

    def to_class
      Object.const_get @class_name
    end
  end
end
