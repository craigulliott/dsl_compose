# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Interpreter
        def initialize dsl_method
          @dsl_method = dsl_method
        end

        private

        def description description
          @dsl_method.set_description description
        end

        def optional name, type, &block
          @dsl_method.add_argument name, false, type, &block
        end

        def requires name, type, &block
          @dsl_method.add_argument name, true, type, &block
        end
      end
    end
  end
end
