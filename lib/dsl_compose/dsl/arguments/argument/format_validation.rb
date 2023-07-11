# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class FormatValidation
          class ValidationFailedError < StandardError
          end

          def initialize regex
            unless regex.is_a?(Regexp)
              raise InvalidValueError, "The value `#{regex}` provided to this validator must be of type Regexp"
            end

            @regex = regex
          end

          def validate! value
            raise ValidationFailedError, "The argument is invalid. Expected format #{@regex} but received #{value}" if @regex.match(value).nil?
            true
          end
        end
      end
    end
  end
end
