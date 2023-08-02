# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodIsUniqueError < StandardError
      end

      class RequiredMethodNotCalledError < StandardError
      end

      attr_reader :dsl
      attr_reader :klass
      attr_reader :method_calls
      attr_reader :arguments

      # execute/process a dynamically defined DSL
      def initialize klass, dsl, *args, &block
        @klass = klass
        @dsl = dsl
        @method_calls = MethodCalls.new
        @arguments = Arguments.new(dsl.arguments, *args)

        # dynamically process the DSL by calling the provided block
        # all methods executions will be caught and processed by the method_missing method below
        if block
          instance_eval(&block)
        end

        # assert that all required methods have been called at least once
        dsl.required_dsl_methods.each do |dsl_method|
          unless @method_calls.method_called? dsl_method.name
            dsl_method_name = dsl_method&.name
            raise RequiredMethodNotCalledError, "The method #{dsl_method_name} is required, but was not called within this DSL"
          end
        end
      end

      # the parser can provide usage notes for how this dsl is being used, these are used to
      # generate documentation
      def add_parser_usage_note note
        @parser_usage_notes ||= []
        @parser_usage_notes << note
      end

      # return the list of notes which describe how the parsers are using this DSL
      def parser_usage_notes
        @parser_usage_notes ||= []
        @parser_usage_notes
      end

      private

      # catch and process any method calls within the DSL block
      def method_missing method_name, *args, &block
        # if the method does not exist, then this will raise a MethodDoesNotExistError
        dsl_method = @dsl.dsl_method method_name

        # if the method is unique, then it can only be called once per DSL
        if dsl_method.unique? && @method_calls.method_called?(method_name)
          raise MethodIsUniqueError, "This method `#{method_name}` is unique and can only be called once within this DSL"
        end

        @method_calls.add_method_call dsl_method, *args, &block
      end

      def respond_to_missing?(method_name, *args)
        @dsl.has_dsl_method? method_name
      end
    end
  end
end
