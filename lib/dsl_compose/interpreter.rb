# frozen_string_literal: true

module DSLCompose
  # The class is reponsible for parsing and executing a dynamic DSL (dynamic DSLs are
  # created using the DSLCompose::DSL class).
  class Interpreter
    # A dynamic DSL can be used multiple times on the same class, each time the DSL is used
    # a corresponding execution will be created. The execution contains the resulting configuration
    # from that particular use of the DSL.
    attr_reader :executions

    def initialize
      @executions = []
    end

    # Execute/process a dynamically defined DSL on a class.
    # `klass` is the class in which the DSL is being used, not
    # the class in which the DSL was defined.
    def execute_dsl klass, dsl, *args, &block
      # make sure we have these variables for the exception message below
      class_name = nil
      class_name = klass.name
      dsl_name = nil
      dsl_name = dsl.name

      execution = Execution.new(klass, dsl, *args, &block)
      @executions << execution
      execution
    rescue => e
      raise e, "Error processing dsl #{dsl_name} for class #{class_name}: #{e.message}", e.backtrace
    end

    # Returns an array of all executions for a given class.
    def class_executions klass
      @executions.filter { |e| e.klass == klass }
    end

    # Returns an array of all executions for a given name.
    def dsl_executions dsl_name
      @executions.filter { |e| e.dsl.name == dsl_name }
    end

    # Returns an array of all executions for a given name and class. This includes
    # any ancestors of the provided class
    def class_dsl_executions klass, dsl_name, on_current_class, on_ancestor_class
      @executions.filter { |e| e.dsl.name == dsl_name && ((on_current_class && e.klass == klass) || (on_ancestor_class && klass < e.klass)) }
    end

    # removes all executions from the interpreter, this is primarily used from
    # within a test suite when dynamically creating classes for tests and then
    # wanting to clear the interpreter before the next test.
    def clear
      @executions = []
    end

    def to_h dsl_name
      h = {}
      dsl_executions(dsl_name).each do |execution|
        h[execution.klass] ||= {
          arguments: execution.arguments.to_h,
          method_calls: {}
        }
        execution.method_calls.method_calls.each do |method_call|
          h[execution.klass][:method_calls][method_call.method_name] ||= []
          h[execution.klass][:method_calls][method_call.method_name] << method_call.to_h
        end
      end
      h
    end

    def executions_by_class
      h = {}
      executions.each do |execution|
        h[execution.klass] ||= {}
        h[execution.klass][execution.dsl.name] ||= []
        execution_h = {
          arguments: execution.arguments.to_h,
          method_calls: {}
        }
        execution.method_calls.method_calls.each do |method_call|
          execution_h[:method_calls][method_call.method_name] ||= []
          execution_h[:method_calls][method_call.method_name] << method_call.to_h
        end
        h[execution.klass][execution.dsl.name] << execution_h
      end
      h
    end
  end
end
