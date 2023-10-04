# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodCalls
        class MethodCall
          class InvalidDescriptionError < InterpreterError
          end

          attr_reader :dsl_method
          attr_reader :called_from
          attr_reader :arguments

          def initialize dsl_method, called_from, *args, &block
            @dsl_method = dsl_method
            @called_from = called_from
            @arguments = Arguments.new(dsl_method.arguments, called_from, *args)
          end

          def method_name
            @dsl_method.name
          end

          def to_h
            {
              arguments: @arguments.to_h
            }
          end

          # the parser can provide usage notes for how this dsl is being used, these are used to
          # generate documentation
          def add_parser_usage_note note
            unless note.is_a?(String) && note.strip.length > 0
              raise InvalidDescriptionError.new("The parser usage description `#{note}` is invalid, it must be of type string and have length greater than 0", @called_from)
            end

            @parser_usage_notes ||= []
            @parser_usage_notes << note.strip
          end

          # return the list of notes which describe how the parsers are using this DSL
          def parser_usage_notes
            @parser_usage_notes ||= []
            @parser_usage_notes
          end
        end
      end
    end
  end
end
