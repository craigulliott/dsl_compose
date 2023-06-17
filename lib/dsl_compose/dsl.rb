# frozen_string_literal: true

module DSLCompose
  # The class is reponsible for creating and representing a dynamic DSL
  #
  # These new dynamic DSL's are created using our own internal DSL, which is accessed
  # by calling `define_dsl` in a class and passing it a block which contains the DSL definition
  class DSL
    class MethodDoesNotExistError < StandardError
      def message
        "This method does not exist for this DSL"
      end
    end

    class MethodAlreadyExistsError < StandardError
      def message
        "This method already exists for this DSL"
      end
    end

    class InvalidNameError < StandardError
      def message
        "This DSL name is invalid, it must be of type symbol"
      end
    end

    class InvalidDescriptionError < StandardError
      def message
        "This DSL description is invalid, it must be of type string and have length greater than 0"
      end
    end

    class DescriptionAlreadyExistsError < StandardError
      def message
        "The DSL description has already been set"
      end
    end

    # The name of this DSL.
    attr_reader :name
    # klass will be the class where `define_dsl` was called.
    attr_reader :klass
    # An otional description of this DSL, if provided then it must be a string.
    # The description accepts markdown and is used when generating documentation.
    attr_reader :description

    # Create a new DSL object with the provided name and class.
    #
    # `name` must be a symbol.
    # `klass` should be the class in which `define_dsl` is being called.
    # `block` contains the DSL definition and will be evaluated to create
    # the rest of the DSL.
    def initialize name, klass, &block
      @dsl_methods = {}

      if name.is_a? Symbol
        @name = name
      else
        raise InvalidNameError
      end

      @klass = klass

      # If a block was provided, then we evaluate it using a seperate
      # interpreter class. We do this because the interpreter class contains
      # no other methods or variables, if it was evaluated in the context of
      # this class then the block would have access to all of the methods defined
      # in here.
      if block
        Interpreter.new(self).instance_eval(&block)
      else
        warn "warning, no dsl block was provided for DSL #{name}"
      end
    end

    # Set the description for this DSL to the provided value.
    #
    # `description` must be a string with a length greater than 0.
    # The `description` can only be set once per DSL
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

    # Takes a method name, unique flag, required flag, and a block and creates
    # a new DSLMethod object.
    #
    # Method `name` must be unique within the DSL.
    def add_method name, unique, required, &block
      if has_dsl_method? name
        raise MethodAlreadyExistsError
      end

      @dsl_methods[name] = DSLMethod.new(name, unique, required, &block)
    end

    # Returns an array of all this DSLs DSLMethods.
    def dsl_methods
      @dsl_methods.values
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
        raise MethodDoesNotExistError
      end
    end

    # Returns `true` if a DSLMethod  with the provided name exists in this
    # DSL, otherwise it returns `false`.
    def has_dsl_method? name
      @dsl_methods.key? name
    end
  end
end
