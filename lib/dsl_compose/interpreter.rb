# frozen_string_literal: true

module DSLCompose
  class Interpreter
    def initialize
      @executions = {}
    end

    # execute/process a dynamically defined DSL on a class
    # klass here is the class in which the dsl is being used, not
    # the class in which the DSL was defined
    def execute_dsl klass, dsl, &block
      @executions[klass] ||= []
      @executions[klass] << Execution.new(dsl, &block)
    end

    def get_executions
      @executions
    end
  end
end
