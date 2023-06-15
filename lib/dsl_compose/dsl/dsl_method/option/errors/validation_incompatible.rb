# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Option
        module Errors

          class ValidationIncompatible < StandardError
            def initialize name, type
              super "The validation #{name} is not compatible with type #{type}."
            end
          end

        end
      end
    end
  end
end