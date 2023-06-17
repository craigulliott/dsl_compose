# frozen_string_literal: true

module DSLCompose
  # The class is reponsible for parsing and executing a dynamic DSL (dynamic DSLs are
  # created using the DSLCompose::DSL class).
  class Interpreter
    # A dynamic DSL can be used multiple times on the same class, each time the dsl is used
    # a corresponding execution will be created. The execution contains the resulting configuration
    # from that particular use of the DSL.
    attr_reader :executions

    def initialize
      @executions = {}
    end

    # Execute/process a dynamically defined DSL on a class.
    # `klass` is the class in which the dsl is being used, not
    # the class in which the DSL was defined.
    def execute_dsl klass, dsl, &block
      @executions[klass] ||= []
      execution = Execution.new(dsl, &block)
      @executions[klass] << execution
      execution
    end

    # Returns an array of all executions for a given class.
    def class_executions klass
      @executions[klass] || []
    end
  end
end
