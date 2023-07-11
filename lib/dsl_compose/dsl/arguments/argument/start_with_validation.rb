# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class StartWithValidation
          class InvalidValueError < StandardError
          end

          class ValidationFailedError < StandardError
          end

          def initialize value
            unless value.is_a?(String)
              raise InvalidValueError, "The value `#{value}` provided to this validator must be of type String"
            end

            @value = value
          end

          def validate! value
            raise ValidationFailedError, "The argument is invalid. Expected `#{value}` to start with `#{@value}`" unless value.start_with? @value
            true
          end
        end
      end
    end
  end
end
