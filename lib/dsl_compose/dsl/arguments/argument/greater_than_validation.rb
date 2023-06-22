# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class GreaterThanValidation
          class InvalidValueError < StandardError
            def message
              "The value provided to validate_greater_than must be a number"
            end
          end

          class ValidationFailedError < StandardError
            def message
              "The argument is invalid"
            end
          end

          def initialize value
            unless value.is_a?(Numeric)
              raise InvalidValueError
            end

            @value = value
          end

          def validate! value
            raise ValidationFailedError unless value > @value
          end
        end
      end
    end
  end
end
