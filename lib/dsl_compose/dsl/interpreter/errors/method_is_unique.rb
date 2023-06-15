# frozen_string_literal: true

module DSLCompose
  class DSL
    class Interpreter
      module Errors
        class MethodIsUnique < StandardError
          def initialize method_name
            "method #{method_name} is unique and can only be called once within this DSL"
          end
        end
      end
    end
  end
end
