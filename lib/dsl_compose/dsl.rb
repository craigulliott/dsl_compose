# frozen_string_literal: true

module DSLCompose
  # The class is reponsible for creating and representing a dynamic DSL
  #
  # These new dynamic DSL's are created using our own internal DSL, which is accessed
  # by calling `define_dsl` in a class and passing it a block which contains the DSL definition
  class DSL
    class MethodDoesNotExistError < StandardError
    end

    class MethodAlreadyExistsError < StandardError
    end

    class InvalidNameError < StandardError
    end

    class InvalidDescriptionError < StandardError
    end

    class DescriptionAlreadyExistsError < StandardError
    end

    class NoBlockProvidedError < StandardError
    end

    # The name of this DSL.
    attr_reader :name
    # klass will be the class where `define_dsl` was called.
    attr_reader :klass
    # An otional description of this DSL, if provided then it must be a string.
    # The description accepts markdown and is used when generating documentation.
    attr_reader :description
    # an object which represents the argument configuration
    attr_reader :arguments

    # Create a new DSL object with the provided name and class.
    #
    # `name` must be a symbol.
    # `klass` should be the class in which `define_dsl` is being called.
    def initialize name, klass
      @dsl_methods = {}

      @arguments = Arguments.new

      if name.is_a? Symbol
        @name = name
      else
        raise InvalidNameError, "The DSL name `#{name}` is invalid, it must be of type symbol"
      end

      @klass = klass
    end

    # Evaluate the configuration block which defines our new DSL
    # `block` contains the DSL definition and will be evaluated to create
    # the rest of the DSL.
    def evaluate_configuration_block &block
      if block
        # We evaluate the internal DSL configuration blocks using a seperate interpreter
        # class. We do this because the interpreter class contains no other methods or
        # variables, if it was evaluated in the context of this class then the block
        # would have access to all of the methods defined in here.
        Interpreter.new(self).instance_eval(&block)
      else
        raise NoBlockProvidedError, "No block was provided for this DSL"
      end
    rescue => e
      raise e, "Error defining DSL #{@name} on #{@klass}: #{e.message}", e.backtrace
    end

    # Set the description for this DSL to the provided value.
    #
    # `description` must be a string with a length greater than 0.
    # The `description` can only be set once per DSL
    def set_description description
      unless description.is_a?(String) && description.length > 0
        raise InvalidDescriptionError, "The DSL description `#{description}` is invalid, it must be of type string and have length greater than 0"
      end

      if has_description?
        raise DescriptionAlreadyExistsError, "The DSL description has already been set"
      end

      @description = description
    end

    # Returns `true` if this DSL has a description, else false.
    def has_description?
      @description.nil? == false
    end

    # Takes a method name, unique flag, required flag, and a block and creates
    # a new DSLMethod object.
    #
    # Method `name` must be unique within the DSL.
    def add_method name, unique, required, &block
      if has_dsl_method? name
        raise MethodAlreadyExistsError, "The method `#{name}` already exists for this DSL"
      end

      @dsl_methods[name] = DSLMethod.new(name, unique, required, &block)
    end

    # Returns an array of all this DSLs DSLMethods.
    def dsl_methods
      @dsl_methods.values
    end

    # does this DSL have any methods
    def has_methods?
      dsl_methods.any?
    end

    # does this DSL have any required methods
    def has_required_methods?
      required_dsl_methods.any?
    end

    # does this DSL have any optional methods
    def has_optional_methods?
      optional_dsl_methods.any?
    end

    # Returns an array of only the required DSLMethods in this DSL.
    def required_dsl_methods
      dsl_methods.filter(&:required?)
    end

    # Returns an array of only the optional DSLMethods in this DSL.
    def optional_dsl_methods
      dsl_methods.filter(&:optional?)
    end

    # returns a specific DSLMethod by it's name, if the DSLMethod does not
    # exist, then an error is raised
    def dsl_method name
      if has_dsl_method? name
        @dsl_methods[name]
      else
        raise MethodDoesNotExistError, "The method `#{name}` does not exist for this DSL"
      end
    end

    # Returns `true` if a DSLMethod  with the provided name exists in this
    # DSL, otherwise it returns `false`.
    def has_dsl_method? name
      @dsl_methods.key? name
    end
  end
end
