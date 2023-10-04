# frozen_string_literal: true

module DSLCompose
  class DSL
    class Arguments
      class Argument
        class ValidationIncompatibleError < StandardError
        end

        class ValidationAlreadyExistsError < StandardError
        end

        class InvalidTypeError < StandardError
        end

        class ImpossibleKwargError < StandardError
        end

        class InvalidNameError < StandardError
        end

        class InvalidDescriptionError < StandardError
        end

        class DescriptionAlreadyExistsError < StandardError
        end

        class ArgumentNameReservedError < StandardError
        end

        class ValidationInvalidArgumentError < StandardError
        end

        RESERVED_ARGUMENT_NAMES = [
          :child_class,
          :dsl_name,
          :method_name
        ].freeze

        # The name of this Argument.
        attr_reader :name
        # An arguments type. This determines what kind of value can be passed when calling the
        # associated DSLMethod.
        # `type` should be set to either :integer, :boolean, :float, :string or :symbol
        attr_reader :type
        # if required, then this Argument must be provided when calling its associated DSLMethod.
        attr_reader :required
        # If true, then this argument must be provided as a keyword argument, this is only appropriate for
        # required arguments, as optional arguments are always passed as keywork arguments.
        # arguments.
        attr_reader :kwarg
        # If true, then this argument accepts an array of values. It will also accept a single value,
        # but that single value will be automatically converted to an array
        attr_reader :array
        # The default value for optional arguments, if one is not provided then nil will be assumed.
        attr_reader :default
        # An otional description of this Attribute, if provided then it must be a string.
        # The description accepts markdown and is used when generating documentation.
        attr_reader :description
        # Optional validations that have been applied to this Argument. When the DSL is used
        # each of these validations will be checked against the value provided to
        # this Argument.
        attr_reader :greater_than_validation
        attr_reader :greater_than_or_equal_to_validation
        attr_reader :less_than_validation
        attr_reader :less_than_or_equal_to_validation
        attr_reader :format_validation
        attr_reader :equal_to_validation
        attr_reader :in_validation
        attr_reader :not_in_validation
        attr_reader :end_with_validation
        attr_reader :not_end_with_validation
        attr_reader :start_with_validation
        attr_reader :not_start_with_validation
        attr_reader :length_validation
        attr_reader :is_a_validation

        # Create a new Attribute object.
        #
        # `name` must be a symbol.
        # `required` is a boolean which determines if this Attribute must be provided when
        # calling its associated DSLMethod.
        # `kwarg` is a boolean which determines if a required Attribute must be provided as a keyword argument.
        # `type` can be either :integer, :boolean, :float, :string or :symbol
        # `block` contains the instructions to further configure this Attribute
        def initialize name, required, kwarg, type, array: false, default: nil, &block
          if name.is_a? Symbol

            if RESERVED_ARGUMENT_NAMES.include? name
              raise ArgumentNameReservedError, "This argument name `#{name}` is a reserved word. The names #{RESERVED_ARGUMENT_NAMES.join ", "} can not be used here because the Parser uses them to express a structural part of the DSL"
            end

            @name = name
          else
            raise InvalidNameError, "The option name `#{name}` is invalid, it must be of type symbol."
          end

          if type == :integer || type == :boolean || type == :float || type == :string || type == :symbol || type == :class || type == :object
            @type = type
          else
            raise InvalidTypeError, "Argument type `#{type}` must be one of :integer, :boolean, :float, :string, :symbol, :class or :object"
          end

          @required = required ? true : false

          if @required == false && kwarg == true
            raise ImpossibleKwargError, "Optional arguments must always be provided as keyword arguments. The argument `#{name}` can not be both required: false and kwarg: true."
          end

          @kwarg = kwarg ? true : false

          @array = array ? true : false

          unless default.nil?
            if @required
              raise ImpossibleKwargError, "The argument `#{name}` is required, so can not be given a default value."
            end
            @default = default
          end

          # If a block was provided, then we evaluate it using a seperate
          # interpreter class. We do this because the interpreter class contains
          # no other methods or variables, if it was evaluated in the context of
          # this class then the block would have access to all of the methods defined
          # in here.
          if block
            Interpreter.new(self).instance_eval(&block)
          end
        rescue => e
          raise e, "Error while defining argument #{name}\n#{e.message}", e.backtrace
        end

        # Set the description for this Argument to the provided value.
        #
        # `description` must be a string with a length greater than 0.
        # The `description` can only be set once per Argument
        def set_description description
          unless description.is_a?(String) && description.strip.length > 0
            raise InvalidDescriptionError, "The option description `#{description}` is invalid, it must be of type string and have length greater than 0."
          end

          if has_description?
            raise DescriptionAlreadyExistsError, "The description has already been set"
          end

          @description = description.strip
        end

        # Returns `true` if this DSL has a description, else false.
        def has_description?
          @description.nil? == false
        end

        # returns true if this DSLMethod is flagged as required, otherwise returns false.
        def required?
          @required == true
        end

        # returns true if this DSLMethod is flagged as optional, otherwise returns false.
        def optional?
          @required == false
        end

        def validate_greater_than value
          if @greater_than_validation
            raise ValidationAlreadyExistsError, "The validation `greater_than` has already been applied to this method option."
          end

          unless value.is_a?(Numeric)
            raise ValidationInvalidArgumentError, value
          end

          unless @type == :integer || @type == :float
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          @greater_than_validation = GreaterThanValidation.new value
        end

        def validate_greater_than_or_equal_to value
          if @greater_than_or_equal_to_validation
            raise ValidationAlreadyExistsError, "The validation `greater_than_or_equal_to` has already been applied to this method option."
          end

          unless value.is_a?(Numeric)
            raise ValidationInvalidArgumentError, value
          end

          unless @type == :integer || @type == :float
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          @greater_than_or_equal_to_validation = GreaterThanOrEqualToValidation.new value
        end

        def validate_less_than value
          if @less_than_validation
            raise ValidationAlreadyExistsError, "The validation `less_than` has already been applied to this method option."
          end

          unless value.is_a?(Numeric)
            raise ValidationInvalidArgumentError, value
          end

          unless @type == :integer || @type == :float
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          @less_than_validation = LessThanValidation.new value
        end

        def validate_less_than_or_equal_to value
          if @less_than_or_equal_to_validation
            raise ValidationAlreadyExistsError, "The validation `less_than_or_equal_to` has already been applied to this method option."
          end

          unless value.is_a?(Numeric)
            raise ValidationInvalidArgumentError, value
          end

          unless @type == :integer || @type == :float
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          @less_than_or_equal_to_validation = LessThanOrEqualToValidation.new value
        end

        def validate_format regexp
          if @format_validation
            raise ValidationAlreadyExistsError, "The validation `format` has already been applied to this method option."
          end

          unless regexp.is_a? Regexp
            raise ValidationInvalidArgumentError, regexp
          end

          unless @type == :string || @type == :symbol || @type == :class
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end
          @format_validation = FormatValidation.new regexp
        end

        def validate_equal_to value
          if @equal_to_validation
            raise ValidationAlreadyExistsError, "The validation `equal_to` has already been applied to this method option."
          end

          unless @type == :integer || @type == :float || @type == :string || @type == :symbol || @type == :boolean
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          @equal_to_validation = EqualToValidation.new value
        end

        def validate_in values
          unless values.is_a? Array
            raise ValidationInvalidArgumentError, values
          end

          unless @type == :integer || @type == :float || @type == :string || @type == :symbol
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          # if this validation has already been applied, then add the values to the existing validation
          if @in_validation
            @in_validation.add_values values
          else
            @in_validation = InValidation.new values
          end
        end

        def validate_not_in values
          unless values.is_a? Array
            raise ValidationInvalidArgumentError, values
          end

          unless @type == :integer || @type == :float || @type == :string || @type == :symbol
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          # if this validation has already been applied, then add the values to the existing validation
          if @not_in_validation
            @not_in_validation.add_values values
          else
            @not_in_validation = NotInValidation.new values
          end
        end

        def validate_end_with value
          valid_type = value.is_a?(Symbol) || value.is_a?(String)
          valid_array_of_symbols = (value.is_a?(Array) && value.all? { |value| value.is_a? Symbol })
          valid_array_of_strings = (value.is_a?(Array) && value.all? { |value| value.is_a? String })
          unless valid_type || valid_array_of_symbols || valid_array_of_strings
            raise ValidationInvalidArgumentError, "The value `#{value}` provided to this validator must be a Symbol/String or an Array of Symbols/Strings"
          end

          unless @type == :string || @type == :symbol || @type == :class
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          # if this validation has already been applied, then add the values to the existing validation
          if @end_with_validation
            @end_with_validation.add_values value
          else
            @end_with_validation = EndWithValidation.new value
          end
        end

        def validate_not_end_with value
          valid_type = value.is_a?(Symbol) || value.is_a?(String)
          valid_array_of_symbols = (value.is_a?(Array) && value.all? { |value| value.is_a? Symbol })
          valid_array_of_strings = (value.is_a?(Array) && value.all? { |value| value.is_a? String })
          unless valid_type || valid_array_of_symbols || valid_array_of_strings
            raise ValidationInvalidArgumentError, "The value `#{value}` provided to this validator must be a Symbol/String or an Array of Symbols/Strings"
          end

          unless @type == :string || @type == :symbol || @type == :class
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          # if this validation has already been applied, then add the values to the existing validation
          if @not_end_with_validation
            @not_end_with_validation.add_values value
          else
            @not_end_with_validation = NotEndWithValidation.new value
          end
        end

        def validate_start_with value
          valid_type = value.is_a?(Symbol) || value.is_a?(String)
          valid_array_of_symbols = (value.is_a?(Array) && value.all? { |value| value.is_a? Symbol })
          valid_array_of_strings = (value.is_a?(Array) && value.all? { |value| value.is_a? String })
          unless valid_type || valid_array_of_symbols || valid_array_of_strings
            raise ValidationInvalidArgumentError, "The value `#{value}` provided to this validator must be a Symbol/String or an Array of Symbols/Strings"
          end

          unless @type == :string || @type == :symbol || @type == :class
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          # if this validation has already been applied, then add the values to the existing validation
          if @start_with_validation
            @start_with_validation.add_values value
          else
            @start_with_validation = StartWithValidation.new value
          end
        end

        def validate_not_start_with value
          valid_type = value.is_a?(Symbol) || value.is_a?(String)
          valid_array_of_symbols = (value.is_a?(Array) && value.all? { |value| value.is_a? Symbol })
          valid_array_of_strings = (value.is_a?(Array) && value.all? { |value| value.is_a? String })
          unless valid_type || valid_array_of_symbols || valid_array_of_strings
            raise ValidationInvalidArgumentError, "The value `#{value}` provided to this validator must be a Symbol/String or an Array of Symbols/Strings"
          end

          unless @type == :string || @type == :symbol || @type == :class
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          # if this validation has already been applied, then add the values to the existing validation
          if @not_start_with_validation
            @not_start_with_validation.add_values value
          else
            @not_start_with_validation = NotStartWithValidation.new value
          end
        end

        def validate_length maximum: nil, minimum: nil, is: nil
          if @length_validation
            raise ValidationAlreadyExistsError, "The validation `length` has already been applied to this method option."
          end

          unless @type == :string || @type == :symbol
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          @length_validation = LengthValidation.new(maximum: maximum, minimum: minimum, is: is)
        end

        def validate_is_a klass
          if @is_a_validation
            raise ValidationAlreadyExistsError, "The validation `is_a` has already been applied to this method option."
          end

          unless @type == :object
            raise ValidationIncompatibleError, "The validation type #{@type} is not compatible with this argument type"
          end

          @is_a_validation = IsAValidation.new(klass)
        end

        # returns true if every provided integer validation also returns true
        def validate_integer! value
          (greater_than_validation.nil? || greater_than_validation.validate!(value)) &&
            (greater_than_or_equal_to_validation.nil? || greater_than_or_equal_to_validation.validate!(value)) &&
            (less_than_validation.nil? || less_than_validation.validate!(value)) &&
            (less_than_or_equal_to_validation.nil? || less_than_or_equal_to_validation.validate!(value)) &&
            (format_validation.nil? || format_validation.validate!(value)) &&
            (equal_to_validation.nil? || equal_to_validation.validate!(value)) &&
            (in_validation.nil? || in_validation.validate!(value)) &&
            (not_in_validation.nil? || not_in_validation.validate!(value)) &&
            (length_validation.nil? || length_validation.validate!(value))
        end

        # returns true if every provided float validation also returns true
        def validate_float! value
          # floats are validated with the same set of validators as integers
          validate_integer! value
        end

        # returns true if every provided symbol validation also returns true
        def validate_symbol! value
          (format_validation.nil? || format_validation.validate!(value)) &&
            (equal_to_validation.nil? || equal_to_validation.validate!(value)) &&
            (in_validation.nil? || in_validation.validate!(value)) &&
            (not_in_validation.nil? || not_in_validation.validate!(value)) &&
            (end_with_validation.nil? || end_with_validation.validate!(value)) &&
            (not_end_with_validation.nil? || not_end_with_validation.validate!(value)) &&
            (start_with_validation.nil? || start_with_validation.validate!(value)) &&
            (not_start_with_validation.nil? || not_start_with_validation.validate!(value)) &&
            (length_validation.nil? || length_validation.validate!(value))
        end

        # returns true if every provided string validation also returns true
        def validate_string! value
          (format_validation.nil? || format_validation.validate!(value)) &&
            (equal_to_validation.nil? || equal_to_validation.validate!(value)) &&
            (in_validation.nil? || in_validation.validate!(value)) &&
            (not_in_validation.nil? || not_in_validation.validate!(value)) &&
            (end_with_validation.nil? || end_with_validation.validate!(value)) &&
            (not_end_with_validation.nil? || not_end_with_validation.validate!(value)) &&
            (start_with_validation.nil? || start_with_validation.validate!(value)) &&
            (not_start_with_validation.nil? || not_start_with_validation.validate!(value)) &&
            (length_validation.nil? || length_validation.validate!(value))
        end

        # returns true if every provided boolean validation also returns true
        def validate_boolean! value
          (equal_to_validation.nil? || equal_to_validation.validate!(value))
        end

        # returns true if every provided class validation also returns true
        def validate_class! value
          (format_validation.nil? || format_validation.validate!(value.class_name)) &&
            (end_with_validation.nil? || end_with_validation.validate!(value.class_name)) &&
            (not_end_with_validation.nil? || not_end_with_validation.validate!(value.class_name)) &&
            (start_with_validation.nil? || start_with_validation.validate!(value.class_name)) &&
            (not_start_with_validation.nil? || not_start_with_validation.validate!(value.class_name))
        end

        # returns true if every provided object validation also returns true
        def validate_object! value
          (is_a_validation.nil? || is_a_validation.validate!(value))
        end
      end
    end
  end
end
