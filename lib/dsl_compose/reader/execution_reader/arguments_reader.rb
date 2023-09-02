# frozen_string_literal: true

module DSLCompose
  class Reader
    class ExecutionReader
      # This class is part of a decorator for DSL executions.
      class ArgumentsReader
        # When instantiated, this class dynamically provides methods which corespiond to argument
        # names and returns the argument value.
        #
        # `arguments` should be the DSL Arguments object, as this represents the possible arguments
        # `argument_values` is a key/value object representing the actual values which were provided
        # when the DSL was executed
        #
        # This class is used to represent both DSL arguments, and dsl_method arguments
        def initialize arguments, argument_values
          @arguments = arguments
          @argument_values = argument_values
        end

        # catch and process any method calls, if arguments exist with the same name
        # as the method call, then return the appropriate value, otherwise raise an error
        def method_missing method_name
          # fetch the argument to ensure it exists (this will raise an error if it does not)
          argument = @arguments.argument method_name
          # return the argument value, or nil if the argument was not used
          @argument_values.arguments[argument.name]
        end

        # returns true if the DSL has an argument with the provided name
        def has_argument? argument_name
          @arguments.has_argument? argument_name
        end

        def respond_to_missing? method_name
          @arguments.has_argument? method_name
        end
      end
    end
  end
end
