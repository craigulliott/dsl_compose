# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class LengthValidation
          class ValidationFailedError < StandardError
          end

          def initialize maximum: nil, minimum: nil, is: nil
            @maximum = maximum
            @minimum = minimum
            @is = is
          end

          def validate! value
            maximum = @maximum
            unless maximum.nil?
              raise ValidationFailedError, "The argument is invalid. Expected #{value} to be less than or equal to #{maximum} characters" if value.length > maximum
            end

            minimum = @minimum
            unless minimum.nil?
              raise ValidationFailedError, "The argument is invalid. Expected #{value} to be greater than or equal to #{minimum} characters" if value.length < minimum
            end

            is = @is
            unless is.nil?
              raise ValidationFailedError, "The argument is invalid. Expected #{value} to be #{is} characters long" if value.length != is
            end

            true
          end
        end
      end
    end
  end
end
