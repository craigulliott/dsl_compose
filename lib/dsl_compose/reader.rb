# frozen_string_literal: true

module DSLCompose
  # This class is a decorator for DSL executions.
  #
  # When a dynamically defined DSL is executed on a class, it creates an execution
  # object which represents the argument values, and any methods and subsequent
  # method argument values which were provided. This class provides a clean and simple
  # API to access those vaues
  class Reader
    class DSLNotFound < StandardError
    end

    # given a class and the DSL name, finds and creates a reference to the DSL
    # and the ancestor class where the DSL was originally defined
    def initialize klass, dsl_name
      # a reference to the class and dsl_name which we want to read values for
      @klass = klass
      @dsl_name = dsl_name

      # Move up through this classes ancestors until we find the class which defined
      # the DSL with the provided name. When we reach the top of the ancestor chain we
      # exit the loop.
      while klass
        # if we find a DSL with this name, then store a reference to the DSL and the
        # ancestor class where it was defined
        if DSLs.class_dsl_exists?(klass, dsl_name)
          @dsl = DSLs.class_dsl(klass, dsl_name)
          @dsl_defining_class = klass
          # stop once we find the DSL
          break
        end

        # the DSL was not found here, so traverse up the provided classes hierachy
        # and keep looking for where this DSL was initially defined
        klass = klass.superclass
      end

      # if no DSL was found, then raise an error
      if @dsl.nil? && @dsl_defining_class.nil?
        raise DSLNotFound, "No DSL named `#{dsl_name}` was found for class `#{klass}`"
      end
    end

    # Returns an ExecutionReader class which exposes a simple API to access the
    # arguments, methods and method arguments provided when using this DSL.
    #
    # If the dsl has been executed once or more on the provided class, then
    # the last (most recent) execution will be returned. If the DSL was not
    # executed on the provided class, then we traverse up the classes ancestors
    # and look for the last time it was executed on each ancestor.
    # If no execution of the DSL is found, then nil will be returned
    def last_execution
      @dsl_defining_class.dsls.get_last_dsl_execution @klass, @dsl_name
    end

    # Returns an array of ExecutionReaders to represent each time the DSL was used
    # on the provided class.
    def executions
      @dsl_defining_class.dsls.class_dsl_executions @klass, @dsl_name, true, false
    end

    # Returns an array of ExecutionReaders to represent each time the DSL was used
    # on the ancestors of the provided class, but not on the provided class itself.
    # The executions will be returned in the order they were executed, which is the
    # earliest ancestor first and if the DSL was used more than once on a class then
    # the order they were used.
    def ancestor_executions
      @dsl_defining_class.dsls.class_dsl_executions @klass, @dsl_name, false, true
    end

    # Returns an array of ExecutionReaders to represent each time the DSL was used
    # on the provided class or ancestors of the provided class. The executions will
    # be returned in the order they were executed, which is the earliest ancestor first
    # and if the DSL was used more than once on a class then the order they were used.
    def all_executions
      @dsl_defining_class.dsls.class_dsl_executions @klass, @dsl_name, true, true
    end
  end
end
