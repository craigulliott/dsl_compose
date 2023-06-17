# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        class GreaterThanOrEqualToValidation
          class InvalidValueError < StandardError
            def message
              "The value provided to validate_greater_than must be a number"
            end
          end

          def initialize value
            unless value.is_a?(Numeric)
              raise InvalidValueError
            end

            @value = value
          end

          def validate value
            value >= @value
          end
        end
      end
    end
  end
end
