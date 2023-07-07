# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class GreaterThanValidation
          class InvalidValueError < StandardError
          end

          class ValidationFailedError < StandardError
          end

          def initialize value
            unless value.is_a?(Numeric)
              raise InvalidValueError, "The value `#{value}` provided to this validator must be of type number"
            end

            @value = value
          end

          def validate! value
            raise ValidationFailedError, "The argument is invalid. Expected greater than #{@value} but received #{value}" unless value > @value
          end
        end
      end
    end
  end
end
