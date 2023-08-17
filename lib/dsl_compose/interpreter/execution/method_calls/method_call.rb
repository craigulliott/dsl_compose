# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodCalls
        class MethodCall
          class InvalidDescriptionError < StandardError
          end

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

          # the parser can provide usage notes for how this dsl is being used, these are used to
          # generate documentation
          def add_parser_usage_note note
            unless note.is_a?(String) && note.strip.length > 0
              raise InvalidDescriptionError, "The parser usage description `#{note}` is invalid, it must be of type string and have length greater than 0"
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
