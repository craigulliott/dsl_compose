# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodIsUniqueError < InterpreterError
      end

      class RequiredMethodNotCalledError < InterpreterError
      end

      class InvalidDescriptionError < InterpreterError
      end

      attr_reader :dsl
      attr_reader :called_from
      attr_reader :klass
      attr_reader :method_calls
      attr_reader :arguments

      # execute/process a dynamically defined DSL
      def initialize klass, dsl, called_from, *args, &block
        @klass = klass
        @dsl = dsl
        @called_from = called_from
        @method_calls = MethodCalls.new
        @arguments = Arguments.new(dsl.arguments, called_from, *args)

        # dynamically process the DSL by calling the provided block
        # all methods executions will be caught and processed by the method_missing method below
        if block
          instance_eval(&block)
        end

        # assert that all required methods have been called at least once
        dsl.required_dsl_methods.each do |dsl_method|
          unless @method_calls.method_called? dsl_method.name
            dsl_method_name = dsl_method&.name
            raise RequiredMethodNotCalledError.new("The method #{dsl_method_name} is required, but was not called within this DSL", called_from)
          end
        end
      end

      # the parser can provide usage notes for how this dsl is being used, these are used to
      # generate documentation
      def add_parser_usage_note note
        unless note.is_a?(String) && note.strip.length > 0
          raise InvalidDescriptionError.new("The parser usage description `#{note}` is invalid, it must be of type string and have length greater than 0", called_from)
        end

        @parser_usage_notes ||= []
        @parser_usage_notes << note.strip
      end

      # return the list of notes which describe how the parsers are using this DSL
      def parser_usage_notes
        @parser_usage_notes ||= []
        @parser_usage_notes
      end

      private

      # catch and process any method calls within the DSL block
      def method_missing(method_name, ...)
        called_from = caller(1..1).first

        # if the method does not exist, then this will raise a MethodDoesNotExistError
        dsl_method = @dsl.dsl_method method_name

        # if the method is unique, then it can only be called once per DSL
        if dsl_method.unique? && @method_calls.method_called?(method_name)
          raise MethodIsUniqueError.new("This method `#{method_name}` is unique and can only be called once within this DSL", called_from)
        end

        @method_calls.add_method_call(dsl_method, called_from, ...)
      end

      def respond_to_missing?(method_name, *args)
        @dsl.has_dsl_method? method_name
      end
    end
  end
end
