# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class MethodCalls
        class MethodCall
          attr_reader :dsl_method
          attr_reader :arguments

          class MissingRequiredArgumentsError < StandardError
            def initialize required_count, provided_count
              super "This method requires #{required_count} arguments, but only #{required_count} were provided"
            end
          end

          class TooManyArgumentsError < StandardError
            def message
              "Too many arguments provided to this method"
            end
          end

          class OptionalArgsShouldBeHashError < StandardError
            def message
              "If provided, then the optional arguments must be last, and be represented as a Hash"
            end
          end

          class InvalidArgumentTypeError < StandardError
            def message
              "The provided argument is the wrong type"
            end
          end

          def initialize dsl_method, *args, &block
            @dsl_method = dsl_method
            @arguments = {}

            required_argument_count = dsl_method.required_arguments.count
            has_optional_arguments = dsl_method.optional_arguments.any?

            # the first N args, where N = required_argument_count, are the
            # provided required arguments
            required_args = args.slice(0, required_argument_count)
            # the optional arg which comes next is the hash which represents
            # all the optional arguments
            optional_arg = args[required_argument_count]

            # assert that a value is provided for every required argument
            unless required_argument_count == required_args.count
              raise MissingRequiredArgumentsError.new required_argument_count, required_args.count
            end

            # assert that too many arguments have not been provided
            if args.count > required_argument_count + (has_optional_arguments ? 1 : 0)
              raise TooManyArgumentsError
            end

            # asset that, if provided, then the optional argument (always the last one) is a Hash
            if has_optional_arguments && optional_arg.nil? === false
              unless optional_arg.is_a? Hash
                raise OptionalArgsShouldBeHashError
              end

              # assert the each provided optional argument is valid
              optional_arg.keys.each do |optional_argument_name|
                optional_arg_value = optional_arg[optional_argument_name]
                optional_argument = dsl_method.optional_argument optional_argument_name

                case optional_argument.type
                when :integer
                  unless optional_arg_value.is_a? Integer
                    raise InvalidArgumentTypeError
                  end
                  optional_argument.validate_integer! optional_arg_value

                when :symbol
                  unless optional_arg_value.is_a? Symbol
                    raise InvalidArgumentTypeError
                  end
                  optional_argument.validate_symbol! optional_arg_value

                when :string
                  unless optional_arg_value.is_a? String
                    raise InvalidArgumentTypeError
                  end
                  optional_argument.validate_string! optional_arg_value

                when :boolean
                  unless optional_arg_value.is_a?(TrueClass) || optional_arg_value.is_a?(FalseClass)
                    raise InvalidArgumentTypeError
                  end
                  optional_argument.validate_boolean! optional_arg_value

                else
                  raise InvalidArgumentTypeError
                end

                # the provided value appears valid for this argument, save the value
                @arguments[optional_argument_name] = optional_arg_value
              end

            end

            # validate the value provided to each required argument
            dsl_method.required_arguments.each_with_index do |required_argument, i|
              arg = args[i]
              case required_argument.type
              when :integer
                unless arg.is_a? Integer
                  raise InvalidArgumentTypeError
                end
                required_argument.validate_integer! arg

              when :symbol
                unless arg.is_a? Symbol
                  raise InvalidArgumentTypeError
                end
                required_argument.validate_symbol! arg

              when :string
                unless arg.is_a? String
                  raise InvalidArgumentTypeError
                end
                required_argument.validate_string! arg

              when :boolean
                unless arg.is_a?(TrueClass) || arg.is_a?(FalseClass)
                  raise InvalidArgumentTypeError
                end
                required_argument.validate_boolean! arg

              else
                raise InvalidArgumentTypeError
              end

              # the provided value appears valid for this argument, save the value
              @arguments[required_argument.name] = arg
            end
          end

          def method_name
            @dsl_method.name
          end

          def to_h
            {
              arguments: @arguments
            }
          end
        end
      end
    end
  end
end
