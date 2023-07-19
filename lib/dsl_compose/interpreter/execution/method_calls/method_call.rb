# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodCalls
        class MethodCall
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
            @parser_usage_notes ||= []
            @parser_usage_notes << DSLCompose::FixHeredocIndentation.fix_heredoc_indentation(note)
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
