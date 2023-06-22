# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class EqualToValidation
          class ValidationFailedError < StandardError
            def message
              "The argument is invalid"
            end
          end

          def initialize value
            @value = value
          end

          def validate! value
            raise ValidationFailedError unless value == @value
          end
        end
      end
    end
  end
end
