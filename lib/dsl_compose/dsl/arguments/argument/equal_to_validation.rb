# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class EqualToValidation
          class ValidationFailedError < StandardError
          end

          def initialize value
            @value = value
          end

          def validate! value
            raise ValidationFailedError, "The argument is invalid. Expected #{@value} but received #{value}" unless value == @value
          end
        end
      end
    end
  end
end
