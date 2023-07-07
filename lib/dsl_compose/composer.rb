# frozen_string_literal: true

module DSLCompose
  module Composer
    class ComposerAlreadyInstalledError < StandardError
    end

    class MethodAlreadyExistsWithThisDSLNameError < StandardError
    end

    class GetDSLExecutionResultsMethodAlreadyExistsError < StandardError
    end

    def self.included klass
      if (klass.private_methods + klass.methods).include? :define_dsl
        raise ComposerAlreadyInstalledError, "This module has already been included or the define_dsl singleton method already exists for this class."
      end

      # create an interpreter for this class which will be shared by all child classes and all
      # the dynamicly defined DSLs in this class
      interpreter = DSLCompose::Interpreter.new

      # return a specific DSL which is defined for this class
      if klass.respond_to? :dsls
        raise GetDSLExecutionResultsMethodAlreadyExistsError, "The `dsls` singleton method already exists for this class."
      end

      klass.define_singleton_method :dsls do
        interpreter
      end

      # return a specific DSL which is defined for this class
      klass.define_singleton_method :define_dsl do |name, &block|
        # Find or create a DSL with this name for the provided class. We allow an existing
        # DSL to be accessed so that it can be be extended (have new methods added to it).
        # `self` here is the class in which `define_dsl` is being called
        if DSLCompose::DSLs.class_dsl_exists? self, name
          # get the existing DSL
          dsl = DSLCompose::DSLs.class_dsl self, name

        else
          dsl = DSLCompose::DSLs.create_dsl self, name

          # ensure that creating this DSL will not override any existing methods on this class
          if respond_to? name
            raise MethodAlreadyExistsWithThisDSLNameError, "The `define_dsl` singleton method `#{name}` already exists for this class."
          end

          # add a singleton method with the name of this new DSL onto our class, this is how our new DSL will be accessed
          define_singleton_method name do |*args, &block|
            # when it is called, we process this new dynamic DSL with the interpreter
            # `self` here is the class in which the dsl is being used, not the class in which the DSL was defined
            interpreter.execute_dsl self, dsl, *args, &block
          end

        end

        # evaluate the configuration block which uses our internal DSL to define this dynamic DSL
        if block
          dsl.evaluate_configuration_block(&block)
        end
      end
    end
  end
end
