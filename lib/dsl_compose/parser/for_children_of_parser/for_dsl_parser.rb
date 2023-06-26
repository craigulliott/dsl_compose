# frozen_string_literal: true

module DSLCompose
  class Parser
    class ForChildrenOfParser
      class ForDSLParser
        class AllBlockParametersMustBeKeywordParametersError < StandardError
          def message
            "All block parameters must be keyword parameters, i.e. `for_dsl :dsl_name do |dsl_name:|`"
          end
        end

        class NoBlockProvided < StandardError
        end

        class DSLDoesNotExistError < StandardError
        end

        class DSLNamesShouldBeSymbolsError < StandardError
          def message
            "DSL names must be provided with a symbol or array of symbols"
          end
        end

        # This class will yield to the provided block once for each time a DSL
        # of the provided name is used by the child class.
        #
        # base_class and child_class are set from the ForChildrenOfParser
        def initialize base_class, child_class, dsl_names, &block
          @base_class = base_class
          @child_class = child_class
          @dsl_names = dsl_names

          # assert that a block was provided
          unless block
            raise NoBlockProvided
          end

          # if any arguments were provided, then assert that they are valid
          if block.parameters.any?
            # all parameters must be keyword arguments
            if block.parameters.filter { |p| p.first != :keyreq }.any?
              raise AllBlockParametersMustBeKeywordParametersError
            end
          end

          # if the provided dsl name is a symbol, then convert it to an array
          if dsl_names.is_a? Symbol
            dsl_names = [dsl_names]
          end

          # assert that the provided dsl name is an array
          unless dsl_names.is_a? Array
            raise DSLNamesShouldBeSymbolsError
          end

          # assert that the provided dsl name is an array of symbols
          unless dsl_names.all? { |dsl_name| dsl_name.is_a? Symbol }
            raise DSLNamesShouldBeSymbolsError
          end

          # assert that the provided dsl names all exist
          unless dsl_names.all? { |dsl_name| DSLs.class_dsl_exists?(base_class, dsl_name) }
            raise DSLDoesNotExistError
          end

          # for each provided dsl name, yield to the provided block
          dsl_names.each do |dsl_name|
            # a dsl can be execued multiple times on a class, so we find all of the executions
            # here and then yield the block once for each execution
            base_class.dsls.class_dsl_executions(child_class, dsl_name).each do |dsl_execution|
              # we only provide the requested arguments to the block, this allows
              # us to use keyword arguments to force a naming convention on these arguments
              # and to validate their use
              args = {}
              if BlockArguments.accepts_argument?(:dsl_name, &block)
                args[:dsl_name] = dsl_execution.dsl.name
              end
              # add any arguments that were provided to the DSL
              dsl_execution.arguments.arguments.each do |name, value|
                if BlockArguments.accepts_argument?(name, &block)
                  args[name] = value
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
      end
    end
  end
end
