# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class InvalidNameError < StandardError
      end

      class MethodNameIsReservedError < StandardError
      end

      class InvalidDescriptionError < StandardError
      end

      class DescriptionAlreadyExistsError < StandardError
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
            raise MethodNameIsReservedError, "This method #{name} would override an existing internal method"
          end

          @name = name
        else
          raise InvalidNameError, "The method name `#{name}` is invalid, it must be of type symbol"
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
      rescue => e
        raise e, "Error while defining method #{name}\n#{e.message}", e.backtrace
      end

      # Set the description for this DSLMethod to the provided value.
      #
      # `description` must be a string with a length greater than 0.
      # The `description` can only be set once per DSLMethod
      def set_description description
        unless description.is_a?(String) && description.strip.length > 0
          raise InvalidDescriptionError, "The DSL method description `#{description}` is invalid, it must be of type string and have length greater than 0"
        end

        if has_description?
          raise DescriptionAlreadyExistsError, "The description has already been set"
        end

        @description = description.strip
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
