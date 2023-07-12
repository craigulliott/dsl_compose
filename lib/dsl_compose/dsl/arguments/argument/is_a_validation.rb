# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class IsAValidation
          class ValidationFailedError < StandardError
          end

          def initialize value
            @value = value
          end

          def validate! value
            raise ValidationFailedError, "The argument is invalid. Expected #{value} to be an instance of #{@value}" unless value.is_a?(@value)
            true
          end
        end
      end
    end
  end
end
