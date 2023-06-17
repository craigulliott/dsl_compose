# frozen_string_literal: true

module DSLCompose
  module Composer
    class ComposerAlreadyInstalled < StandardError
      def message
        "The define_dsl singleton method already exists for this class."
      end
    end

    def self.included klass
      if (klass.private_methods + klass.methods).include? :define_dsl
        raise ComposerAlreadyInstalledError
      end

      # create an interpreter for this class which will be shared by all child classes and all
      # the dynamicly defined DSLs in this class
      dsl_interpreter = DSLCompose::Interpreter.new

      # return all the DSLs defined for this class
      warn "WARNING: #{klass} already defines a method called get_dsls, this method will be overridden" if klass.respond_to? :get_dsls
      klass.define_singleton_method :get_dsls do
        DSLCompose::DSLs.class_dsls klass
      end

      # return a specific DSL which is defined for this class
      warn "WARNING: #{klass} already defines a method called get_dsl, this method will be overridden" if klass.respond_to? :get_dsl
      klass.define_singleton_method :get_dsl do |name|
        DSLCompose::DSLs.class_dsl klass, name
      end

      # return a specific DSL which is defined for this class
      warn "WARNING: #{klass} already defines a method called define_dsl, this method will be overridden" if klass.respond_to? :define_dsl
      klass.define_singleton_method :define_dsl do |name, &block|
        # parse the internal DSL and create a dynamic DSL for use in our class
        # `self` here is the class in which `define_dsl` is being called
        dsl = DSLCompose::DSLs.create_dsl self, name, &block

        # add a singleton method witht the name of this new DSL onto our class, this is how our new DSL will be accessed
        warn "WARNING: #{klass} already defines a method called #{name}, this method will be overridden" if klass.respond_to? name
        define_singleton_method name do |&block|
          # when it is called, we process this new dynamic DSL with the interpreter
          # `self` here is the class in which the dsl is being used, not the class in which the DSL was defined
          dsl_interpreter.execute_dsl self, dsl, &block
        end
      end
    end
  end
end
