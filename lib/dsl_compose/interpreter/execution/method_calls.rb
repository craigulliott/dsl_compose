# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodCalls
        attr_reader :method_calls

        def initialize
          @method_calls = []
        end

        def method_called? method_name
          @method_calls.filter { |mc| mc.method_name == method_name }.any?
        end

        def add_method_call(dsl_method, ...)
          # make sure we always have a variable which can be used in the exception message
          dsl_method_name = nil
          dsl_method_name = dsl_method.name

          method_call = MethodCall.new(dsl_method, ...)
          @method_calls << method_call
          method_call
        rescue => e
          raise e, "Error while executing method #{dsl_method_name}: #{e.message}", e.backtrace
        end

        def method_calls_by_name method_name
          @method_calls.filter { |mc| mc.method_name == method_name }
        end
      end
    end
  end
end
