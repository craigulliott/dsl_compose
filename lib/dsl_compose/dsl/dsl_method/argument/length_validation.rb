# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        class LengthValidation
          class ValidationFailedError < StandardError
            def message
              "The argument is invalid"
            end
          end

          def initialize maximum: nil, minimum: nil, is: nil
            @maximum = maximum
            @minimum = minimum
            @is = is
          end

          def validate! value
            maximum = @maximum
            unless maximum.nil?
              raise ValidationFailedError if value.length > maximum
            end

            minimum = @minimum
            unless minimum.nil?
              raise ValidationFailedError if value.length < minimum
            end

            is = @is
            unless is.nil?
              raise ValidationFailedError if value.length != is
            end

            true
          end
        end
      end
    end
  end
end
