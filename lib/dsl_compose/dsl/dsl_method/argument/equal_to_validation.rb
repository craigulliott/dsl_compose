# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        class EqualToValidation
          def initialize value
            @value = value
          end

          def validate value
            value == @value
          end
        end
      end
    end
  end
end
