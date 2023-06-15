# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        class Interpreter
          def initialize argument
            @argument = argument
          end

          private

          def description description
            @argument.set_description description
          end

          def validate_greater_than value
            @argument.add_validation :greater_than, value
          end

          def validate_greater_than_or_equal_to value
            @argument.add_validation :greater_than_or_equal_to, value
          end

          def validate_less_than value
            @argument.add_validation :less_than, value
          end

          def validate_less_than_or_equal_to value
            @argument.add_validation :less_than_or_equal_to, value
          end

          def validate_equal_to value
            @argument.add_validation :equal_to, value
          end

          def validate_length minimum: nil, maximum: nil, is: nil
            @argument.add_validation :length, {minimum: minimum, maximum: maximum, is: is}
          end

          def validate_not_in values
            @argument.add_validation :not_in, value
          end

          def validate_in values
            @argument.add_validation :in, value
          end

          def validate_format regex
            @argument.add_validation :format, value
          end
        end
      end
    end
  end
end
