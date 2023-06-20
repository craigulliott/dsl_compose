# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        class FormatValidation
          class ValidationFailedError < StandardError
            def message
              "The argument is invalid"
            end
          end

          def initialize regex
            @regex = regex
          end

          def validate! value
            raise ValidationFailedError if @regex.match(value).nil?
          end
        end
      end
    end
  end
end
