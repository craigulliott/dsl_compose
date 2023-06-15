# frozen_string_literal: true

module DSLCompose
  class DSL
    class Interpreter
      module Errors

        class MethodDoesNotExist < StandardError
          def initialize method_name
            "method #{method_name} does not exist on this DSL"
          end
        end

      end
    end
  end
end