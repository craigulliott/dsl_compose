# frozen_string_literal: true

module DSLCompose
  class DSL
    class Interpreter
      class Result
        def initialize
          @result = {}
        end

        def method_called? name
          @result.key? name
        end

        def add_method_call name
          @result[name] = true
        end
      end
    end
  end
end
