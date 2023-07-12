# frozen_string_literal: true

module DSLCompose
  class Interpreter
    class Execution
      class Arguments
        class MissingRequiredArgumentsError < StandardError
        end

        class TooManyArgumentsError < StandardError
        end

        class OptionalArgumentsShouldBeHashError < StandardError
        end

        class InvalidArgumentTypeError < StandardError
        end

        attr_reader :arguments

        def initialize arguments, *args
          @arguments = {}

          required_argument_count = arguments.required_arguments.count
          has_optional_arguments = arguments.optional_arguments.any?

          # the first N args, where N = required_argument_count, are the
          # provided required arguments
          required_args = args.slice(0, required_argument_count)
          # the optional arg which comes next is the hash which represents
          # all the optional arguments
          optional_arg = args[required_argument_count]

          # assert that a value is provided for every required argument
          unless required_argument_count == required_args.count
            raise MissingRequiredArgumentsError, "This requires #{required_argument_count} arguments, but only #{required_args.count} were provided"
          end

          # assert that too many arguments have not been provided
          if args.count > required_argument_count + (has_optional_arguments ? 1 : 0)
            raise TooManyArgumentsError, "Too many arguments provided"
          end

          # asset that, if provided, then the optional argument (always the last one) is a Hash
          if has_optional_arguments && optional_arg.nil? === false
            unless optional_arg.is_a? Hash
              raise OptionalArgumentsShouldBeHashError, "If provided, then the optional arguments must be last, and be represented as a Hash"
            end

            # assert the each provided optional argument is valid
            optional_arg.keys.each do |optional_argument_name|
              optional_arg_value = optional_arg[optional_argument_name]
              optional_argument = arguments.optional_argument optional_argument_name

              case optional_argument.type
              when :integer
                unless optional_arg_value.is_a? Integer
                  raise InvalidArgumentTypeError, "#{optional_arg_value} is not an Integer"
                end
                optional_argument.validate_integer! optional_arg_value

              when :symbol
                unless optional_arg_value.is_a? Symbol
                  raise InvalidArgumentTypeError, "#{optional_arg_value} is not a Symbol"
                end
                optional_argument.validate_symbol! optional_arg_value

              when :string
                unless optional_arg_value.is_a? String
                  raise InvalidArgumentTypeError, "#{optional_arg_value} is not a String"
                end
                optional_argument.validate_string! optional_arg_value

              when :boolean
                unless optional_arg_value.is_a?(TrueClass) || optional_arg_value.is_a?(FalseClass)
                  raise InvalidArgumentTypeError, "#{optional_arg_value} is not a boolean"
                end
                optional_argument.validate_boolean! optional_arg_value

              else
                raise InvalidArgumentTypeError, "The argument #{optional_arg_value} is not a supported type"
              end

              # the provided value appears valid for this argument, save the value
              @arguments[optional_argument_name] = optional_arg_value

            rescue => e
              raise e, "Error processing optional argument #{optional_argument_name}: #{e.message}", e.backtrace
            end

          end

          # validate the value provided to each required argument
          arguments.required_arguments.each_with_index do |required_argument, i|
            # make sure we always have an argument_name for the exception below
            argument_name = nil
            argument_name = required_argument.name

            arg = args[i]
            case required_argument.type
            when :integer
              unless arg.is_a? Integer
                raise InvalidArgumentTypeError, "#{arg} is not an Integer"
              end
              required_argument.validate_integer! arg

            when :symbol
              unless arg.is_a? Symbol
                raise InvalidArgumentTypeError, "#{arg} is not a Symbol"
              end
              required_argument.validate_symbol! arg

            when :string
              unless arg.is_a? String
                raise InvalidArgumentTypeError, "#{arg} is not a String"
              end
              required_argument.validate_string! arg

            when :boolean
              unless arg.is_a?(TrueClass) || arg.is_a?(FalseClass)
                raise InvalidArgumentTypeError, "#{arg} is not a boolean"
              end
              required_argument.validate_boolean! arg

            else
              raise InvalidArgumentTypeError, "The argument #{arg} is not a supported type"
            end

            # the provided value appears valid for this argument, save the value
            @arguments[required_argument.name] = arg

          rescue => e
            raise e, "Error processing required argument #{argument_name}: #{e.message}", e.backtrace
          end
        end

        def to_h
          @arguments
        end
      end
    end
  end
end
