# frozen_string_literal: true

module DSLCompose
  class Parser
    class ForChildrenOfParser
      class ForDSLParser
        class ForMethodParser
          class AllBlockParametersMustBeKeywordParametersError < StandardError
          end

          class NoBlockProvided < StandardError
          end

          class MethodDoesNotExistError < StandardError
          end

          class MethodNamesShouldBeSymbolsError < StandardError
          end

          # This class will yield to the provided block once for each time a method
          # with the provided name is called within a DSL called on the child class.
          #
          # base_class and child_class are set from the ForChildrenOfParser
          # dsl_execution is set from the ForDSLParser
          def initialize base_class, child_class, dsl_execution, method_names, &block
            @base_class = base_class
            @child_class = child_class
            @dsl_execution = dsl_execution
            @method_names = method_names

            # assert that a block was provided
            unless block
              raise NoBlockProvided
            end

            # if any arguments were provided, then assert that they are valid
            if block.parameters.any?
              # all parameters must be keyword arguments
              if block.parameters.filter { |p| p.first != :keyreq }.any?
                raise AllBlockParametersMustBeKeywordParametersError, "All block parameters must be keyword parameters, i.e. `for_children_of FooClass do |base_class:|`"
              end
            end

            # if the provided dsl name is a symbol, then convert it to an array
            if method_names.is_a? Symbol
              method_names = [method_names]
            end

            # assert that the provided dsl name is an array
            unless method_names.is_a? Array
              raise MethodNamesShouldBeSymbolsError, "Method names `#{method_names}` must be provided with a symbol or array of symbols"
            end

            # assert that the provided dsl name is an array of symbols
            unless method_names.all? { |method_name| method_name.is_a? Symbol }
              raise MethodNamesShouldBeSymbolsError, "Method names `#{method_names}` must be provided with a symbol or array of symbols"
            end

            # assert that the provided method names all exist for the scoped DSL
            unless method_names.all? { |method_name| dsl_execution.dsl.has_dsl_method?(method_name) }
              raise MethodDoesNotExistError, "Method names `#{method_names}` must all exist"
            end

            # for each provided dsl name, yield to the provided block
            method_names.each do |method_name|
              # we only provide the requested arguments to the block, this allows
              # us to use keyword arguments to force a naming convention on these arguments
              # and to validate their use
              args = {}
              if BlockArguments.accepts_argument?(:method_name, &block)
                args[:method_name] = method_name
              end

              # methods can be executed multiple times, so yield once for each method call
              # add any arguments that were provided to the DSL method
              dsl_execution.method_calls.method_calls_by_name(method_name).each do |method_call|
                # add any arguments that were provided to the method call
                method_call.arguments.arguments.each do |name, value|
                  if BlockArguments.accepts_argument?(name, &block)
                    args[name] = value
                  end
                end

                # yeild the block in the context of this class
                instance_exec(**args, &block)
              end
            end
          end
        end
      end
    end
  end
end
