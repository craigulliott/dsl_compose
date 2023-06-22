# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class ArgumentDoesNotExistError < StandardError
        def message
          "This argument does not exist for this DSLMethod"
        end
      end

      class InvalidNameError < StandardError
        def message
          "The method #{method_name} is invalid, it must be of type symbol"
        end
      end

      class MethodNameIsReservedError < StandardError
        def message
          "This method already would override an existing internal method"
        end
      end

      class InvalidDescriptionError < StandardError
        def message
          "The DSL method description is invalid, it must be of type string and have length greater than 0"
        end
      end

      class DescriptionAlreadyExistsError < StandardError
        def message
          "The description has already been set"
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

      # The name of this DSLMethod.
      attr_reader :name
      # if unique, then this DSLMethod can only be called once within the DSL.
      attr_reader :unique
      # if required, then this DSLMethod must be called at least once within the DSL.
      attr_reader :required
      # An otional description of this DSLMethod, if provided then it must be a string.
      # The description accepts markdown and is used when generating documentation.
      attr_reader :description
      # an object which represents the argument configuration
      attr_reader :arguments

      # Create a new DSLMethod object with the provided name and class.
      #
      # `name` must be a symbol.
      # `unique` is a boolean which determines if this DSLMethod can only be called once witihn the DSL.
      # `required` is a boolean which determines if this DSLMethod must be called at least once within the DSL.
      # `block` contains the instructions to further configure this DSLMethod
      def initialize name, unique, required, &block
        @arguments = Arguments.new

        if name.is_a? Symbol

          # don't allow methods to override existing internal methods
          if Class.respond_to? name
            raise MethodNameIsReservedError
          end

          @name = name
        else
          raise InvalidNameError
        end

        @unique = unique ? true : false
        @required = required ? true : false

        # If a block was provided, then we evaluate it using a seperate
        # interpreter class. We do this because the interpreter class contains
        # no other methods or variables, if it was evaluated in the context of
        # this class then the block would have access to all of the methods defined
        # in here.
        if block
          Interpreter.new(self).instance_eval(&block)
        end
      end

      # Set the description for this DSLMethod to the provided value.
      #
      # `description` must be a string with a length greater than 0.
      # The `description` can only be set once per DSLMethod
      def set_description description
        unless description.is_a?(String) && description.length > 0
          raise InvalidDescriptionError
        end

        if has_description?
          raise DescriptionAlreadyExistsError
        end

        @description = description
      end

      # Returns `true` if this DSL has a description, else false.
      def has_description?
        @description.nil? == false
      end

      # returns true if this DSLMethod is flagged as unique, otherwise returns false.
      def unique?
        @unique == true
      end

      # returns true if this DSLMethod is flagged as required, otherwise returns false.
      def required?
        @required == true
      end

      # returns true if this DSLMethod is flagged as optional, otherwise returns false.
      def optional?
        @required == false
      end
    end
  end
end
