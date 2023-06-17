# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        class NotInValidation
          class InvalidValueError < StandardError
            def message
              "The value provided to validate_greater_than must be a number"
            end
          end

          def initialize values
            unless values.is_a?(Array)
              raise InvalidValueError
            end

            @values = values
          end

          def validate value
            !@values.include?(value)
          end
        end
      end
    end
  end
end
