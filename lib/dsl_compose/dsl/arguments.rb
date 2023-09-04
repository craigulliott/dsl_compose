# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class ArgumentDoesNotExistError < StandardError
      end

      class ArgumentOrderingError < StandardError
      end

      class ArgumentAlreadyExistsError < StandardError
      end

      class RequestedOptionalArgumentIsRequiredError < StandardError
      end

      class RequestedRequiredArgumentIsOptionalError < StandardError
      end

      def initialize
        @arguments = {}
      end

      # returns true if there are any arguments, otherwise returns false
      def any?
        @arguments.values.any?
      end

      # Returns an array of all this DSLMethods Argument objects.
      def arguments
        @arguments.values
      end

      # Returns an array of only the optional Argument objects on this DSLMethod.
      def optional_arguments
        arguments.filter(&:optional?)
      end

      # Returns an array of only the required Argument objects on this DSLMethod.
      def required_arguments
        arguments.filter(&:required?)
      end

      # returns a specific Argument by it's name, if the Argument does not
      # exist, then an error is raised
      def argument name
        if has_argument? name
          @arguments[name]
        else
          raise ArgumentDoesNotExistError, "The argument `#{name}` does not exist for this DSLMethod"
        end
      end

      # returns a specific optional Argument by it's name, if the Argument does not
      # exist, or if it is required, then an error is raised
      def optional_argument name
        arg = argument name
        if arg.optional?
          @arguments[name]
        else
          raise RequestedOptionalArgumentIsRequiredError, "A specific argument `#{name}` which was expected to be optional was requested, but the argument found was flagged as required"
        end
      end

      # returns a specific required Argument by it's name, if the Argument does not
      # exist, or if it is optional, then an error is raised
      def required_argument name
        arg = argument name
        if arg.required?
          @arguments[name]
        else
          raise RequestedRequiredArgumentIsOptionalError, "A specific argument `#{name}` which was expected to be required was requested, but the argument found was flagged as optional"
        end
      end

      # Returns `true` if an Argument with the provided name exists in this
      # DSLMethod, otherwise it returns `false`.
      def has_argument? name
        @arguments.key? name
      end

      # Takes a method name, unique flag, required flag, and a block and creates
      # a new Argument object.
      #
      # Argument `name` must be unique within the DSLMethod.
      # `required` must be a boolean, and determines if this argument will be required
      # `kwarg` is a boolean which determines if a required Attribute must be provided as a keyword argument.
      # or optional on the method which is exposed in our DSL.
      def add_argument name, required, kwarg, type, array: false, &block
        if @arguments.key? name
          raise ArgumentAlreadyExistsError, "An argument with the name `#{name}` already exists for this DSL method"
        end

        # required arguments may not come after optional ones
        if required && optional_arguments.any?
          raise ArgumentOrderingError, "Required arguments can not be added after optional ones"
        end

        @arguments[name] = Argument.new(name, required, kwarg, type, array: array, &block)
      end
    end
  end
end
