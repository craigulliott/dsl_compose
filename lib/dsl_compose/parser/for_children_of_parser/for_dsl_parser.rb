# frozen_string_literal: true

module DSLCompose
  class Parser
    class ForChildrenOfParser
      class ForDSLParser
        class AllBlockParametersMustBeKeywordParametersError < StandardError
        end

        class NoBlockProvided < StandardError
        end

        class DSLDoesNotExistError < StandardError
        end

        class DSLNamesShouldBeSymbolsError < StandardError
        end

        # This class will yield to the provided block once for each time a DSL
        # of the provided name is used by the child class.
        #
        # base_class and child_class are set from the ForChildrenOfParser
        def initialize base_class, child_class, dsl_names, on_current_class, on_ancestor_class, &block
          @base_class = base_class
          @child_class = child_class
          @dsl_names = dsl_names

          # assert that a block was provided
          unless block
            raise NoBlockProvided
          end

          # if any arguments were provided, then assert that they are valid
          if block&.parameters&.any?
            # all parameters must be keyword arguments
            if block.parameters.filter { |p| p.first != :keyreq }.any?
              raise AllBlockParametersMustBeKeywordParametersError, "All block parameters must be keyword parameters, i.e. `for_dsl :dsl_name do |dsl_name:|`"
            end
          end

          # if the provided dsl name is a symbol, then convert it to an array
          if dsl_names.is_a? Symbol
            dsl_names = [dsl_names]
          end

          # assert that the provided dsl name is an array
          unless dsl_names.is_a? Array
            raise DSLNamesShouldBeSymbolsError, "DSL names `#{dsl_names}` must be provided with a symbol or array of symbols"
          end

          # assert that the provided dsl name is an array of symbols
          unless dsl_names.all? { |dsl_name| dsl_name.is_a? Symbol }
            raise DSLNamesShouldBeSymbolsError, "DSL names `#{dsl_names}` must be provided with a symbol or array of symbols"
          end

          # assert that the provided dsl names all exist
          unless dsl_names.all? { |dsl_name| DSLs.class_dsl_exists?(base_class, dsl_name) }
            raise DSLDoesNotExistError, "DSLs named `#{dsl_names}` must all exist"
          end

          # for each provided dsl name, yield to the provided block
          dsl_names.each do |dsl_name|
            # a dsl can be execued multiple times on a class, so we find all of the executions
            # here and then yield the block once for each execution
            base_class.dsls.class_dsl_executions(child_class, dsl_name, on_current_class, on_ancestor_class).each do |dsl_execution|
              # we only provide the requested arguments to the block, this allows
              # us to use keyword arguments to force a naming convention on these arguments
              # and to validate their use
              args = {}

              # the dsl name (if it's requested)
              if BlockArguments.accepts_argument?(:dsl_name, &block)
                args[:dsl_name] = dsl_execution.dsl.name
              end

              # a hash representation of all the dsl arguments, if requested
              if BlockArguments.accepts_argument?(:dsl_arguments, &block)
                args[:dsl_arguments] = {}
                # process each argument, because we might need to coerce it
                dsl_execution.arguments.arguments.each do |name, value|
                  # if this value is a ClassCoerce object, then convert it from its original
                  # string value to a class
                  args[:dsl_arguments][name] = value.is_a?(ClassCoerce) ? value.to_class : value
                end
              end

              # an ExecutionReader object to access the exections methods (if it's requested)
              if BlockArguments.accepts_argument?(:reader, &block)
                args[:reader] = Reader::ExecutionReader.new(dsl_execution)
              end

              # add any arguments that were provided to the DSL
              dsl_execution.arguments.arguments.each do |name, value|
                if BlockArguments.accepts_argument?(name, &block)
                  # if this value is a ClassCoerce object, then convert it from its original
                  # string value to a class
                  args[name] = value.is_a?(ClassCoerce) ? value.to_class : value
                end
              end

              # set the dsl_execution in an instance variable so that method calls to `for_method`
              # from within the block will have access to it
              @dsl_execution = dsl_execution
              # yield the block in the context of this class
              instance_exec(**args, &block)
            end
          end
        end

        private

        # Given a method name, or array of method names, this method will yield to the
        # provided block once for each time a dsl method with one of the provided names
        # was used within one of the correspondng dsls, on each child_class
        #
        # The values of base_class and child_class are set from the yield of the parent
        # class (ForChildrenOfParser) initializer, the value of dsl_execution is set from
        # this classes initializer, meaning that the use of this method should look
        # something like this:
        #
        # for_children_of PlatformRecord do |base_class:|
        #   for_dsl [:number_field, :float_field] do |name:|
        #     for_method :some_method_name do |method_name:, a_method_argument:|
        #       ...
        #     end
        #   end
        # end
        def for_method method_names, &block
          ForMethodParser.new(@base_class, @child_class, @dsl_execution, method_names, &block)
        end

        # Given a method name, will return true if the method was called within the current DSL
        # execution, otherwise it will return false
        def method_called? method_name
          # get the dsl method from the current dsl execution, this
          # will raise an error if the method does not exist
          dsl_method = @dsl_execution.dsl.dsl_method(method_name)
          # was this method called within the current DSL execution?
          @dsl_execution.method_calls.method_called? dsl_method.name
        end

        # takes a description of what this parser does and stores it against the DSL definition
        # of the current @child_class, this is used to generate documentation for what the parser
        # has done with the DSL
        def description description
          @dsl_execution.add_parser_usage_note description
        end
      end
    end
  end
end
