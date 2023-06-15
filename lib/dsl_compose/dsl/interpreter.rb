# frozen_string_literal: true

module DSLCompose
  class DSL
    class Interpreter
      def initialize dsl
        @dsl = dsl
      end

      private

      def description description
        @dsl.set_description description
      end

      def add_method name, required: nil, &block
        @dsl.add_method name, false, required, &block
      end

      def add_unique_method name, required: nil, &block
        @dsl.add_method name, true, required, &block
      end
    end
  end
end
