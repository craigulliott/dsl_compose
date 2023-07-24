# frozen_string_literal: true

module DSLCompose
  class Reader
    # This class is a decorator for DSL executions.
    #
    # When a dynamically defined DSL is executed on a class, it creates an execution
    # object which represents the argument values, and any methods and subsequent
    # method argument values which were provided. This class provides a clean and simple
    # API to access those vaues
    class ExecutionReader
      class InvalidExecution < StandardError
      end

      class MethodDoesNotExist < StandardError
      end

      def initialize execution
        raise InvalidExecution unless execution.is_a? Interpreter::Execution
        @execution = execution
      end

      # returns an object which represents the arguments available for this DSL and allows
      # accessing their values via methods
      def arguments
        ArgumentsReader.new @execution.dsl.arguments, @execution.arguments
      end

      # was a method with the provided name called during the use of this DSL
      def method_called? method_name
        unless @execution.dsl.has_dsl_method? method_name
          raise MethodDoesNotExist, "The method `#{method_name}` does not exist for DSL `#{@execution.dsl.name}`"
        end
        @execution.method_calls.method_called? method_name
      end

      # Catch and process any method calls, if a DSL method with the same name exists
      # then return a representation of the arguments which were provided to the execution
      # of that method within the DSL.
      #
      # If the method is marked as unique, then an arguments object will be returned, if the
      # method is not unique, then an array of arguments objects will be returned (one for each
      # time the method was used within this DSL execution).
      def method_missing method_name
        # Fetch the method from the DSL (this will raise an error if a method with this name
        # was not defined for this exections DSL).
        dsl_method = @execution.dsl.dsl_method method_name

        # the Arguments object which represents the possible arguments which can be
        # used with this method
        arguments = dsl_method.arguments

        # Fetch the array of method calls, this represents each use of a DSL method within
        # a single use of the DSL
        method_calls = @execution.method_calls.method_calls_by_name(method_name)

        # If the use of this DSL method is only allowed once per DSL execution, then return
        # an ArgumentsReader object which represents the argument values provided when the
        # method was used.
        #
        # If the method was never used, then nil will be returned. We don't have to validate
        # if the method use is required or not here, because that validation already happened
        # when the DSL was used.
        if dsl_method.unique?
          method_call = method_calls.first
          unless method_call.nil?
            ArgumentsReader.new arguments, method_call.arguments
          end

        # If the method call is not unique, then return an array representing the argument
        # values provided for each use of the DSL method
        else
          method_calls.map do |method_call|
            ArgumentsReader.new arguments, method_call.arguments
          end
        end
      end

      def respond_to_missing? method_name
        method_called? method_name
      end
    end
  end
end
