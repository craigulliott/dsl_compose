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

          def initialize values
            @values = []
            add_values values
          end

          def add_values values
            # if the provided values is a single item then convert it to an array
            if values.is_a?(Symbol) || values.is_a?(String)
              values = [values]
            end

            # assert that the provided values is an array
            unless values.is_a? Array
              raise ValidationFailedError, "The value `#{values}` provided to this validator must be a Symbol/String or an Array of Symbols/Strings"
            end

            # assert that the provided values is an array of symbols/strings
            unless values.all? { |value| value.is_a? Symbol } || values.all? { |value| value.is_a? String }
              raise ValidationFailedError, "The value `#{values}` provided to this validator must be a Symbol/String or an Array of Symbols/Strings"
            end

            @values += values
          end

          def validate! value
            raise ValidationFailedError, "The argument is invalid. Expected `#{value}` to start with `#{@values}`" unless @values.filter { |v| value.start_with? v.to_s }.any?
            true
          end
        end
      end
    end
  end
end
