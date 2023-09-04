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

        class ArrayNotValidError < StandardError
        end

        attr_reader :arguments

        def initialize arguments, *args
          @arguments = {}

          required_argument_count = arguments.required_arguments.count
          required_non_kwarg_argument_count = arguments.required_arguments.filter { |a| !a.kwarg }.count
          has_optional_arguments = arguments.optional_arguments.any?

          # the first N args, where N = required_non_kwarg_argument_count, are the
          # provided required arguments
          required_args = args.slice(0, required_non_kwarg_argument_count)

          # the final argument is the object which contains all the keyword args (these keyword
          # args could be optional or required)
          all_kwargs = args[required_non_kwarg_argument_count]

          # process all the required arguments which are kwargs
          required_kwargs = arguments.required_arguments.filter { |a| a.kwarg }
          required_kwargs.each do |required_kwarg|
            if all_kwargs.key? required_kwarg.name
              # add the keyword argument to the required args
              required_args << all_kwargs[required_kwarg.name]
              # delete the required kwarg from the kwargs hash, so that we are
              # left with only the optional args
              all_kwargs.delete required_kwarg.name
            else
              raise MissingRequiredArgumentsError, "The required kwarg `#{required_kwarg.name}` was not provided"
            end
          end

          # at this point, all_kwargs should be a hash which only represents
          # the optional arguments
          optional_arg = all_kwargs

          # assert that a value is provided for every required argument
          unless required_argument_count == required_args.count
            raise MissingRequiredArgumentsError, "This requires #{required_non_kwarg_argument_count} arguments, but only #{required_args.count} were provided"
          end

          # assert that too many arguments have not been provided
          if args.count > required_argument_count + (has_optional_arguments ? 1 : 0)
            raise TooManyArgumentsError, "Too many arguments provided"
          end

          # Assume all optonal arguments are nil (except booleans, which default to false).
          # If actual values were provided, then they will be set further below.
          if arguments.optional_arguments.any?
            arguments.optional_arguments.each do |optional_argument|
              # assume it is nil
              @arguments[optional_argument.name] = nil
              # unless the argument is an array or a boolean, in which case it defaults
              # to an empty array or false
              if optional_argument.array
                @arguments[optional_argument.name] = []
              elsif optional_argument.type == :boolean
                @arguments[optional_argument.name] = false
              end
            end
          end

          # asset that, if provided, then the optional argument (always the last one) is a Hash
          if has_optional_arguments && !optional_arg.nil?
            unless optional_arg.is_a? Hash
              raise OptionalArgumentsShouldBeHashError, "If provided, then the optional arguments must be last, and be represented as a Hash"
            end

            # assert the each provided optional argument is valid
            optional_arg.keys.each do |optional_argument_name|
              optional_argument = arguments.optional_argument optional_argument_name

              # the value for class types are wrapped in a ClassCoerce class so that they can be
              # treated specially by the parser (it automatically converts them from a string name
              # to the corresponding class, logic which doesn't happen here in case the class doesnt
              # exist yet)
              optional_arg_value = if optional_argument.type == :class
                if optional_arg[optional_argument_name].is_a?(Array)
                  optional_arg[optional_argument_name].map { |v| ClassCoerce.new v }
                else
                  ClassCoerce.new optional_arg[optional_argument_name]
                end
              else
                optional_arg[optional_argument_name]
              end

              if optional_arg_value.is_a?(Array) && !optional_argument.array
                raise ArrayNotValidError, "An array was provided to an argument which does not accept an array of values"
              end

              # to simplify the code, we always process the reset of the validations as an array, even
              # if the argument is not of type array
              values = optional_arg_value.is_a?(Array) ? optional_arg_value : [optional_arg_value]

              values.each do |value|
                case optional_argument.type
                when :integer
                  unless value.is_a? Integer
                    raise InvalidArgumentTypeError, "`#{value}` is not an Integer"
                  end
                  optional_argument.validate_integer! value

                when :float
                  # float allows either floats or integers
                  unless value.is_a?(Float) || value.is_a?(Integer)
                    raise InvalidArgumentTypeError, "`#{value}` is not an Float or Integer"
                  end
                  optional_argument.validate_float! value

                when :symbol
                  unless value.is_a? Symbol
                    raise InvalidArgumentTypeError, "`#{value}` is not a Symbol"
                  end
                  optional_argument.validate_symbol! value

                when :string
                  unless value.is_a? String
                    raise InvalidArgumentTypeError, "`#{value}` is not a String"
                  end
                  optional_argument.validate_string! value

                when :boolean
                  unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
                    raise InvalidArgumentTypeError, "`#{value}` is not a boolean"
                  end
                  optional_argument.validate_boolean! value

                when :class
                  unless value.is_a?(ClassCoerce)
                    raise InvalidArgumentTypeError, "`#{value}` is not a class coerce (String)"
                  end
                  optional_argument.validate_class! value

                when :object
                  optional_argument.validate_object! value

                else
                  raise InvalidArgumentTypeError, "The argument value `#{value}` is not a supported type"
                end
              end

              # The provided value appears valid for this argument, save the value.
              #
              # If the argument accepts an array of values, then automatically convert valid singular values
              # into an array.
              @arguments[optional_argument_name] = if optional_argument.array && !optional_arg_value.is_a?(Array)
                [optional_arg_value]
              else
                optional_arg_value
              end
            rescue => e
              raise e, "Error processing optional argument #{optional_argument_name}: #{e.message}", e.backtrace
            end

          end

          # validate the value provided to each required argument
          arguments.required_arguments.each_with_index do |required_argument, i|
            # make sure we always have an argument_name for the exception below
            argument_name = nil
            argument_name = required_argument.name

            # the value for class types are wrapped in a ClassCoerce class so that they can be
            # treated specially by the parser (it automatically converts them from a string name
            # to the corresponding class, logic which doesn't happen here in case the class doesnt
            # exist yet)
            required_arg_value = if required_argument.type == :class
              if required_args[i].is_a?(Array)
                required_args[i].map { |v| ClassCoerce.new v }
              else
                ClassCoerce.new required_args[i]
              end
            else
              required_args[i]
            end

            if required_arg_value.is_a?(Array) && !required_argument.array
              raise ArrayNotValidError, "An array was provided to an argument which does not accept an array of values"
            end

            # to simplify the code, we always process the reset of the validations as an array, even
            # if the argument is not of type array
            values = required_arg_value.is_a?(Array) ? required_arg_value : [required_arg_value]

            values.each do |value|
              case required_argument.type
              when :integer
                unless value.is_a? Integer
                  raise InvalidArgumentTypeError, "`#{value}` is not an Integer"
                end
                required_argument.validate_integer! value

              when :float
                # float allows either floats or integers
                unless value.is_a?(Float) || value.is_a?(Integer)
                  raise InvalidArgumentTypeError, "`#{value}` is not an Float or Integer"
                end
                required_argument.validate_float! value

              when :symbol
                unless value.is_a? Symbol
                  raise InvalidArgumentTypeError, "`#{value}` is not a Symbol"
                end
                required_argument.validate_symbol! value

              when :string
                unless value.is_a? String
                  raise InvalidArgumentTypeError, "`#{value}` is not a String"
                end
                required_argument.validate_string! value

              when :boolean
                unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
                  raise InvalidArgumentTypeError, "`#{value}` is not a boolean"
                end
                required_argument.validate_boolean! value

              when :class
                unless value.is_a?(ClassCoerce)
                  raise InvalidArgumentTypeError, "`#{value}` is not a class coerce (String)"
                end
                required_argument.validate_class! value

              when :object
                required_argument.validate_object! value

              else
                raise InvalidArgumentTypeError, "The argument `#{value}` is not a supported type"
              end
            end

            # The provided value appears valid for this argument, save the value.
            #
            # If the argument accepts an array of values, then automatically convert valid singular values
            # into an array.
            @arguments[argument_name] = if required_argument.array && !required_arg_value.is_a?(Array)
              [required_arg_value]
            else
              required_arg_value
            end
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
