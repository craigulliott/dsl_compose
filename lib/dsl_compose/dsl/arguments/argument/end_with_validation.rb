# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class EndWithValidation
          class InvalidValueError < StandardError
          end

          class ValidationFailedError < StandardError
          end

          def initialize values
            # if the provided values is a symbol, then convert it to an array
            if values.is_a? Symbol
              values = [values]
            end

            # assert that the provided values is an array
            unless values.is_a? Array
              raise ValidationFailedError, "The value `#{values}` provided to this validator must be a Symbol or an Array of Symbols"
            end

            # assert that the provided values is an array of symbols
            unless values.all? { |value| value.is_a? Symbol }
              raise ValidationFailedError, "The value `#{values}` provided to this validator must be a Symbol or an Array of Symbols"
            end

            @values = values
          end

          def validate! value
            raise ValidationFailedError, "The argument is invalid. Expected `#{value}` to end with `#{@values}`" unless @values.filter { |v| value.end_with? v.to_s }.any?
            true
          end
        end
      end
    end
  end
end
