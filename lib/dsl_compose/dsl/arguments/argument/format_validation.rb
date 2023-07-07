# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class FormatValidation
          class ValidationFailedError < StandardError
          end

          def initialize regex
            @regex = regex
          end

          def validate! value
            raise ValidationFailedError, "The argument is invalid. Expected format #{@regex} but received #{value}" if @regex.match(value).nil?
          end
        end
      end
    end
  end
end
