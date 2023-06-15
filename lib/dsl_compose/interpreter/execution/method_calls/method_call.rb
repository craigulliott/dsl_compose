# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodCalls
        class MethodCall
          def initialize dsl_method, *args, &block
            @dsl_method = dsl_method

            # assert that each required argument has been provided
            # required_argument_count = dsl_method.required_argument_count
            # h

            # dsl_method.required_arguments.each do |required_argument|
          end

          def method_name
            @dsl_method.name
          end
        end
      end
    end
  end
end
