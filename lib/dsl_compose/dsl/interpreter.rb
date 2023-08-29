# frozen_string_literal: true

module DSLCompose
  class DSL
    # The class is reponsible for parsing and executing our internal DSL which is used to define
    # a new dynamic DSL. This class is instantaited by the DSLCompose::DSL class and our internal
    # DSL is evaluated by passing a block to `instance_eval` on this class.
    #
    # An example of our internal DSL:
    #  define_dsl :my_dsl do
    #    description "This is my DSL"
    #    add_method :my_method do
    #      # ...
    #    end
    #    add_unique_method :my_uniq_method do
    #      # ...
    #    end
    #  end
    class Interpreter
      def initialize dsl
        @dsl = dsl
      end

      private

      # sets the description of the DSL
      def description description
        @dsl.set_description description
      end

      # sets the namespace of the DSL, this is used
      # to group DSLs together in documentation
      def namespace namespace
        @dsl.set_namespace namespace
      end

      # sets the title of the DSL
      def title title
        @dsl.set_title title
      end

      # adds a new method to the DSL
      #
      # methods flagged as `required` will cause your DSLs to raise an error
      # if they are not used at least once within your new DSLs
      # `block` contains the method definition and will be evaluated seperately
      # by the DSLMethod::Interpreter
      def add_method name, required: nil, &block
        @dsl.add_method name, false, required ? true : false, &block
      end

      # adds a new unique method to the DSL
      #
      # methods flagged as `required` will cause your DSLs to raise an error
      # if they are not used at least once within your new DSLs
      # `block` contains the method definition and will be evaluated seperately
      # by the DSLMethod::Interpreter
      def add_unique_method name, required: nil, &block
        @dsl.add_method name, true, required ? true : false, &block
      end

      # adds a new optional argument to the DSLMethod
      #
      # name must be a symbol
      # `type` can be either :integer, :boolean, :float, :string, :symbol, :class or :object
      # `block` contains the argument definition and will be evaluated seperately
      # by the Argument::Interpreter
      def optional name, type, array: false, &block
        @dsl.arguments.add_argument name, false, type, array: array, &block
      end

      # adds a new required argument to the DSLMethod
      #
      # name must be a symbol
      # `type` can be either :integer, :boolean, :float, :string, :symbol, :class or :object
      # `block` contains the argument definition and will be evaluated seperately
      # by the Argument::Interpreter
      def requires name, type, array: false, &block
        @dsl.arguments.add_argument name, true, type, array: array, &block
      end

      # executes the shared configuration block with the given name within the
      # context of this part of the DSL, this is a mechanism to share configuration
      # between DSLs
      def import_shared shared_configuration_name
        block = SharedConfiguration.get shared_configuration_name
        instance_eval(&block)
      end
    end
  end
end
