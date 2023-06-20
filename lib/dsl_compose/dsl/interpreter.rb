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
    end
  end
end
