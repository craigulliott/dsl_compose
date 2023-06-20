# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        # This class is reponsible for parsing and executing argument definitions
        # within our internal DSL. These argument definitions determine what arguments
        # will be available on the methods within our new dynamic DSL.
        #
        # This class is instantaited by the DSLCompose::DSL::DSLMethod::Argument class and the
        # method argument definition part of our internal DSL is evaluated by passing a block
        # to `instance_eval` on this class.
        #
        # An example of our internal DSL which includes a method definition with complex arguments:
        #  define_dsl :my_dsl do
        #    add_method :my_method, required: true do
        #      description "Description of my method"
        #      optional :my_optional_argument, :string do
        #        description "A description of this argument"
        #        validate_greater_than 10
        #      end
        #      optional :my_optional_arg, String
        #    end
        #  end
        class Interpreter
          def initialize argument
            @argument = argument
          end

          private

          # sets the description of the Argument
          def description description
            @argument.set_description description
          end

          # adds a greater_than validator to the argument
          def validate_greater_than value
            @argument.validate_greater_than value
          end

          # adds a greater_than_or_equal_to validator to the argument
          def validate_greater_than_or_equal_to value
            @argument.validate_greater_than_or_equal_to value
          end

          # adds a less_than validator to the argument
          def validate_less_than value
            @argument.validate_less_than value
          end

          # adds a less_than_or_equal_to validator to the argument
          def validate_less_than_or_equal_to value
            @argument.validate_less_than_or_equal_to value
          end

          # adds a equal_to validator to the argument
          def validate_equal_to value
            @argument.validate_equal_to value
          end

          # adds a length validator to the argument
          def validate_length minimum: nil, maximum: nil, is: nil
            @argument.validate_length minimum: minimum, maximum: maximum, is: is
          end

          # adds a not_in validator to the argument
          def validate_not_in values
            @argument.validate_not_in values
          end

          # adds a in validator to the argument
          def validate_in values
            @argument.validate_in values
          end

          # adds a format validator to the argument
          def validate_format regexp
            @argument.validate_format regexp
          end
        end
      end
    end
  end
end
