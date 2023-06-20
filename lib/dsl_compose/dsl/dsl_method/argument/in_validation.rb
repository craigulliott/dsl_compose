# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        class InValidation
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

          def initialize values
            unless values.is_a?(Array)
              raise InvalidValueError
            end

            @values = values
          end

          def validate! value
            raise ValidationFailedError unless @values.include? value
          end
        end
      end
    end
  end
end
