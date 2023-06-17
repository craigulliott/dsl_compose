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

      # The name of this DSLMethod.
      attr_reader :name
      # if unique, then this DSLMethod can only be called once within the DSL.
      attr_reader :unique
      # if required, then this DSLMethod must be called at least once within the DSL.
      attr_reader :required
      # An otional description of this DSLMethod, if provided then it must be a string.
      # The description accepts markdown and is used when generating documentation.
      attr_reader :description

      # Create a new DSLMethod object with the provided name and class.
      #
      # `name` must be a symbol.
      # `unique` is a boolean which determines if this DSLMethod can only be called once witihn the DSL.
      # `required` is a boolean which determines if this DSLMethod must be called at least once within the DSL.
      # `block` contains the instructions to further configure this DSLMethod
      def initialize name, unique, required, &block
        @arguments = {}

        if name.is_a? Symbol
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

      # Returns `true` if an Argument with the provided name exists in this
      # DSLMethod, otherwise it returns `false`.
      def has_argument? name
        @arguments.key? name
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
