# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class InterpreterError < StandardError
      attr_reader :original_context

      def initialize(message, original_context)
        super(message)
        @original_context = original_context
      end

      def to_s
        "#{super}\ndsl source: #{@original_context}"
      end
    end
  end
end
