# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodCalls
        class MethodCall
          attr_reader :dsl_method
          attr_reader :arguments

          class MissingRequiredArgumentsError < StandardError
            def initialize required_count, provided_count
              super "This method requires #{required_count} arguments, but only #{required_count} were provided"
            end
          end

          class TooManyArgumentsError < StandardError
            def message
              "Too many arguments provided to this method"
            end
          end

          class OptionalArgsShouldBeHashError < StandardError
            def message
              "If provided, then the optional arguments must be last, and be represented as a Hash"
            end
          end

          class InvalidArgumentTypeError < StandardError
            def message
              "The provided argument is the wrong type"
            end
          end

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
