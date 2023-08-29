# frozen_string_literal: true

module DSLCompose
  # The class is reponsible for parsing and executing a dynamic DSL (dynamic DSLs are
  # created using the DSLCompose::DSL class).
  class Interpreter
    class DSLExecutionNotFoundError < StandardError
    end

    class InvalidDescriptionError < StandardError
    end

    # A dynamic DSL can be used multiple times on the same class, each time the DSL is used
    # a corresponding execution will be created. The execution contains the resulting configuration
    # from that particular use of the DSL.
    attr_reader :executions

    def initialize
      @executions = []
    end

    # the parser can provide usage notes for how this dsl is being used, these are used to
    # generate documentation
    def add_parser_usage_note child_class, note
      unless note.is_a?(String) && note.strip.length > 0
        raise InvalidDescriptionError, "The parser usage description `#{note}` is invalid, it must be of type string and have length greater than 0"
      end
      @parser_usage_notes ||= {}
      @parser_usage_notes[child_class] ||= []
      @parser_usage_notes[child_class] << note.strip
    end

    # return the list of notes which describe how the parsers are using this DSL
    def parser_usage_notes child_class
      @parser_usage_notes ||= {}
      @parser_usage_notes[child_class] ||= []
      @parser_usage_notes[child_class]
    end

    # Execute/process a dynamically defined DSL on a class.
    # `klass` is the class in which the DSL is being used, not
    # the class in which the DSL was defined.
    def execute_dsl(klass, dsl, ...)
      # make sure we have these variables for the exception message below
      class_name = nil
      class_name = klass.name
      dsl_name = nil
      dsl_name = dsl.name

      execution = Execution.new(klass, dsl, ...)
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

    # returns the most recent, closest single execution of a dsl with the
    # provided name for the provided class
    #
    # If the dsl has been executed once or more on the provided class, then
    # the last (most recent) execution will be returned. If the DSL was not
    # executed on the provided class, then we traverse up the classes ancestors
    # until we reach the ancestor where the DSL was originally defined and test
    # each of them and return the first most recent execution of the DSL.
    # If no execution of the DSL is found, then nil will be returned
    def get_last_dsl_execution klass, dsl_name
      # note that this method does not need to do any special sorting, the required
      # order for getting the most recent execution is already guaranteed because
      # parent classes in ruby always have to be evaluated before their descendents
      class_dsl_executions(klass, dsl_name, true, true).last
    end

    # removes all executions from the interpreter, and any parser_usage_notes
    # this is primarily used from within a test suite when dynamically creating
    # classes for tests and then wanting to clear the interpreter before the
    # next test.
    def clear
      @executions = []
      @parser_usage_notes = {}
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
