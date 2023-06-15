# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodCalls
        def initialize
          @method_calls = []
        end

        def method_called? method_name
          @method_calls.filter { |mc| mc.method_name == method_name }.any?
        end

        def add_method_call dsl_method, *args, &block
          @method_calls << MethodCall.new(dsl_method, *args, &block)
        end
      end
    end
  end
end
