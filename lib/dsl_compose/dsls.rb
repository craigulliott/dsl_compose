# frozen_string_literal: true

module DSLCompose
  module DSLs

    class ClassDSLDefinitionDoesNotExistError < StandardError
      def message
        super "The requested DSL does not exist on this class"
      end
    end

    class DSLAlreadyExistsError < StandardError
      def message
        super "A DSL with this name already exists"
      end
    end

    class NoDSLDefinitionsForClassError < StandardError
      def message
        super "No DSLs have been defined for this class"
      end
    end

    # an object to hold all of the defined DSLs in our application, the DSLs are
    # organized by the class in which they were defined
    @dsls = {}

    # create a new DSL definition for a class
    # `klass` here is the class in which `define_dsl` was called
    def self.create_dsl klass, name, &block
      @dsls[klass] ||= {}

      if @dsls[klass].key? name
        raise DSLAlreadyExistsError
      end

      @dsls[klass][name] = DSLCompose::DSL.new(name, klass, &block)
    end

    # return all of the DSL definitions
    def self.dsls
      @dsls
    end

    # return an array of DSL definitions for a provided class, if no DSLs
    # exist for the provided class, then an error is raised
    def self.class_dsls klass
      if @dsls.key? klass
        @dsls[klass].values
      else
        raise NoDSLDefinitionsForClassError
      end
    end

    # return a specific DSL definition for a provided class
    # if it does not exist, then an error is raised
    def self.class_dsl klass, name
      if @dsls.key? klass
        if @dsls[klass].key? name
          @dsls[klass][name]
        else
          raise ClassDSLDefinitionDoesNotExistError
        end
      else
        raise NoDSLDefinitionsForClassError
      end
    end

    # removes all DSL deinitions, this method is typically used by the test
    # suite for resetting state inbetween each test
    def self.reset
      @dsls = {}
    end
  end
end
