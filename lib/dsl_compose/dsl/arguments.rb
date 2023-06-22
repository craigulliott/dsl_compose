# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class ArgumentDoesNotExistError < StandardError
        def message
          "This argument does not exist for this DSLMethod"
        end
      end

      class ArgumentOrderingError < StandardError
        def message
          "Required arguments can not be added after optional ones"
        end
      end

      class ArgumentAlreadyExistsError < StandardError
        def message
          "An argument with this name already exists for this DSL method"
        end
      end

      class RequestedOptionalArgumentIsRequiredError < StandardError
        def message
          "A specific argument which was expected to be optional was requested, but the argument found was flagged as required"
        end
      end

      class RequestedRequiredArgumentIsOptionalError < StandardError
        def message
          "A specific argument which was expected to be required was requested, but the argument found was flagged as optional"
        end
      end

      def initialize
        @arguments = {}
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
          raise ArgumentDoesNotExistError
        end
      end

      # returns a specific optional Argument by it's name, if the Argument does not
      # exist, or if it is required, then an error is raised
      def optional_argument name
        arg = argument name
        if arg.optional?
          @arguments[name]
        else
          raise RequestedOptionalArgumentIsRequiredError
        end
      end

      # returns a specific required Argument by it's name, if the Argument does not
      # exist, or if it is optional, then an error is raised
      def required_argument name
        arg = argument name
        if arg.required?
          @arguments[name]
        else
          raise RequestedRequiredArgumentIsOptionalError
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
      # or optional on the method which is exposed in our DSL.
      def add_argument name, required, type, &block
        if @arguments.key? name
          raise ArgumentAlreadyExistsError
        end

        # required arguments may not come after optional ones
        if required && optional_arguments.any?
          raise ArgumentOrderingError
        end

        @arguments[name] = Argument.new(name, required, type, &block)
      end
    end
  end
end
