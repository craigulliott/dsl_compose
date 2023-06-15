# frozen_string_literal: true

module DSLCompose
  module Composer
    def self.included klass
      if (klass.private_methods + klass.methods).include? :define_dsl
        raise Errors::ComposerAlreadyInstalled
      end
      # install the ClassMethods module into the class which included this module, this will add any methods defined within
      # ClassMethods into the class as singleton methods
      klass.extend(ClassMethods)

      # this method is defined here rather than in ClassMethods because it requires access to the klass variable
      klass.define_singleton_method :get_dsls do
        DSLCompose::DSLs.get_class_dsls klass
      end

      # this method is defined here rather than in ClassMethods because it requires access to the klass variable
      klass.define_singleton_method :get_dsl do |name|
        DSLCompose::DSLs.get_class_dsl klass, name
      end
    end

    module ClassMethods
      def get_dsl name
        DSLCompose::DSLs.get_class_dsl self, name
      end

      private

      def define_dsl name, &block
        # create the DSL object
        dsl = DSLCompose::DSLs.create_dsl self, name, &block

        # create an interpreter for this DSL
        interpreter = DSLCompose::DSL::Interpreter.new dsl

        # define a singleton method on the class to access this DSL
        define_singleton_method name do |*args, &block|
          # dynamically process the DSL with the interpreter
          interpreter.instance_eval(&block)

          # assert that all required methods have been called at least once
          dsl.get_dsl_methods.filter(&:required?).each do |dsl_method|
            unless dsl.get_results.method_called? dsl_method.get_name
              raise Errors::RequiredMethodNotCalled.new dsl_method.get_name
            end
          end
        end
      end
    end
  end
end
