# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodIsUniqueError < StandardError
        def message
          "This method is unique and can only be called once within this DSL"
        end
      end

      # execute/process a dynamically defined DSL
      def initialize dsl, &block
        @method_calls = MethodCalls.new
        @dsl = dsl

        # dynamically process the DSL by calling the provided block
        # all methods executions will be caught and processed by the method_missing method below
        if block
          instance_eval(&block)
        end

        # assert that all required methods have been called at least once
        dsl.required_dsl_methods.each do |dsl_method|
          unless @method_calls.method_called? dsl_method.name
            raise RequiredMethodNotCalledError
          end
        end
      end

      private

      # catch and process any method calls within the DSL block
      def method_missing method_name, *args, &block
        # if the method does not exist, then this will raise a MethodDoesNotExistError
        dsl_method = @dsl.dsl_method method_name

        # if the method is unique, then it can only be called once per DSL
        if dsl_method.unique? && @method_calls.method_called?(method_name)
          raise MethodIsUniqueError
        end

        @method_calls.add_method_call dsl_method, *args, &block
      end

      def respond_to_missing?(method_name, *args)
        @dsl.has_dsl_method? method_name
      end
    end
  end
end
