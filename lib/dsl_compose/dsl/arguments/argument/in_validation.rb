# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class InValidation
          class InvalidValueError < StandardError
          end

          class ValidationFailedError < StandardError
          end

          def initialize values
            @values = []
            add_values values
          end

          def add_values values
            unless values.is_a?(Array)
              raise InvalidValueError, "The value `#{values}` provided to this validator must be of type Array"
            end

            @values += values
          end

          def validate! value
            raise ValidationFailedError, "The argument is invalid. Expected in #{@values} but received #{value}" unless @values.include? value
            true
          end
        end
      end
    end
  end
end
