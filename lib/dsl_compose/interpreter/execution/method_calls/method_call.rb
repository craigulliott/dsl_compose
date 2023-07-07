# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodCalls
        class MethodCall
          attr_reader :dsl_method
          attr_reader :arguments

          def initialize dsl_method, *args, &block
            @dsl_method = dsl_method
            @arguments = Arguments.new(dsl_method.arguments, *args)
          end

          def method_name
            @dsl_method.name
          end

          def to_h
            {
              arguments: @arguments.to_h
            }
          end
        end
      end
    end
  end
end
