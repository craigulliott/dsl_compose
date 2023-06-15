# frozen_string_literal: true

module DSLCompose
  class DSL
    class Interpreter
      def initialize dsl
        @dsl = dsl
        # the result of executing the DSL
        @result = Result.new
      end

      # catch and process any method calls within the DSL block
      def method_missing name, *args, &block
        dsl_method = @dsl.get_dsl_method name
        if dsl_method
          method_name = dsl_method.get_name

          # if the method is unique, then it can only be called once per DSL
          if dsl_method.unique? && @result.method_called?(method_name)
            raise Errors::MethodIsUnique.new method_name
          end

          @result.add_method_call method_name

        else
          raise Errors::MethodDoesNotExist.new name
        end
      end

      def respond_to_missing?(method_name, *args)
        @dsl.has_dsl_method? name
      end

      def get_results
        @result
      end
    end
  end
end
