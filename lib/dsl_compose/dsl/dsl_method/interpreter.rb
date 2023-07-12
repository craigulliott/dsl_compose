# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      # This class is reponsible for parsing and executing method definitions
      # within our internal DSL. These method definitions determine what methods
      # will be available within our new dynamic DSL.
      #
      # This class is instantaited by the DSLCompose::DSL::DSLMethod class and the method definition
      # part of our internal DSL is evaluated by passing a block to `instance_eval` on this class.
      #
      # An example of our internal DSL which includes a complex method definition:
      #  define_dsl :my_dsl do
      #    add_method :my_method, required: true do
      #      description "Description of my method"
      #      optional :my_optional_argument, :string do
      #        # ...
      #      end
      #      optional :my_optional_arg, String
      #    end
      #  end
      class Interpreter
        def initialize dsl_method
          @dsl_method = dsl_method
        end

        private

        # sets the description of the DSLMethod
        def description description
          @dsl_method.set_description description
        end

        # adds a new optional argument to the DSLMethod
        #
        # name must be a symbol
        # `type` can be either :integer, :boolean, :float, :string or :symbol
        # `block` contains the argument definition and will be evaluated seperately
        # by the Argument::Interpreter
        def optional name, type, &block
          @dsl_method.arguments.add_argument name, false, type, &block
        end

        # adds a new required argument to the DSLMethod
        #
        # name must be a symbol
        # `type` can be either :integer, :boolean, :float, :string or :symbol
        # `block` contains the argument definition and will be evaluated seperately
        # by the Argument::Interpreter
        def requires name, type, &block
          @dsl_method.arguments.add_argument name, true, type, &block
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
end
