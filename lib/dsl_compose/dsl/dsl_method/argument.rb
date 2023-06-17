# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        class ValidationIncompatibleError < StandardError
          def message
            "The validation is not compatible with this argument type"
          end
        end

        class ValidationAlreadyExistsError < StandardError
          def message
            "This validation has already been applied to this method option."
          end
        end

        class InvalidTypeError < StandardError
          def message
            "Argument type must be one of :integer, :boolean, :float, :string or :symbol"
          end
        end

        class InvalidNameError < StandardError
          def message
            "The option name is invalid, it must be of type symbol."
          end
        end

        class InvalidDescriptionError < StandardError
          def message
            "The option description is invalid, it must be of type string and have length greater than 0."
          end
        end

        class DescriptionAlreadyExistsError < StandardError
          def message
            "The description has already been set"
          end
        end

        # The name of this Argument.
        attr_reader :name
        # An arguments type. This determines what kind of value can be passed when calling the
        # associated DSLMethod.
        # `type` should be set to either :integer, :boolean, :float, :string or :symbol
        attr_reader :type
        # if required, then this Argument must be provided when calling its associated DSLMethod.
        attr_reader :required
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
        attr_reader :length_validation

        # Create a new Attribute object.
        #
        # `name` must be a symbol.
        # `required` is a boolean which determines if this Attribute must be provided when
        # calling its associated DSLMethod.
        # `type` can be either :integer, :boolean, :float, :string or :symbol
        # `block` contains the instructions to further configure this Attribute
        def initialize name, required, type, &block
          if name.is_a? Symbol
            @name = name
          else
            raise InvalidNameError
          end

          if type == :integer || type == :boolean || type == :float || type == :string || type == :symbol
            @type = type
          else
            raise InvalidTypeError
          end

          @required = required ? true : false

          # If a block was provided, then we evaluate it using a seperate
          # interpreter class. We do this because the interpreter class contains
          # no other methods or variables, if it was evaluated in the context of
          # this class then the block would have access to all of the methods defined
          # in here.
          if block
            Interpreter.new(self).instance_eval(&block)
          end
        end

        # Set the description for this Argument to the provided value.
        #
        # `description` must be a string with a length greater than 0.
        # The `description` can only be set once per Argument
        def set_description description
          unless description.is_a?(String) && description.length > 0
            raise InvalidDescriptionError
          end

          if has_description?
            raise DescriptionAlreadyExistsError
          end

          @description = description
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
            raise ValidationAlreadyExistsError
          end

          unless @type == :integer || @type == :float
            raise ValidationIncompatibleError
          end

          @greater_than_validation = GreaterThanValidation.new value
        end

        def validate_greater_than_or_equal_to value
          if @greater_than_or_equal_to_validation
            raise ValidationAlreadyExistsError
          end

          unless value.is_a?(Numeric)
            raise ValidationInvalidArgumentError
          end

          unless @type == :integer || @type == :float
            raise ValidationIncompatibleError
          end

          @greater_than_or_equal_to_validation = GreaterThanOrEqualToValidation.new value
        end

        def validate_less_than value
          if @less_than_validation
            raise ValidationAlreadyExistsError
          end

          unless value.is_a?(Numeric)
            raise ValidationInvalidArgumentError
          end

          unless @type == :integer || @type == :float
            raise ValidationIncompatibleError
          end

          @less_than_validation = LessThanValidation.new value
        end

        def validate_less_than_or_equal_to value
          if @less_than_or_equal_to_validation
            raise ValidationAlreadyExistsError
          end

          unless value.is_a?(Numeric)
            raise ValidationInvalidArgumentError
          end

          unless @type == :integer || @type == :float
            raise ValidationIncompatibleError
          end

          @less_than_or_equal_to_validation = LessThanOrEqualToValidation.new value
        end

        def validate_format regexp
          if @format_validation
            raise ValidationAlreadyExistsError
          end

          unless regexp.is_a? Regexp
            raise ValidationInvalidArgumentError
          end

          unless @type == :string || @type == :symbol
            raise ValidationIncompatibleError
          end
          @format_validation = FormatValidation.new regexp
        end

        def validate_equal_to value
          if @equal_to_validation
            raise ValidationAlreadyExistsError
          end

          unless @type == :integer || @type == :float || @type == :string || @type == :symbol || @type == :boolean
            raise ValidationIncompatibleError
          end

          @equal_to_validation = EqualToValidation.new value
        end

        def validate_in values
          if @in_validation
            raise ValidationAlreadyExistsError
          end

          unless values.is_a? Array
            raise ValidationInvalidArgumentError
          end

          unless @type == :integer || @type == :float || @type == :string || @type == :symbol
            raise ValidationIncompatibleError
          end

          @in_validation = InValidation.new values
        end

        def validate_not_in values
          if @not_in_validation
            raise ValidationAlreadyExistsError
          end

          unless values.is_a? Array
            raise ValidationInvalidArgumentError
          end

          unless @type == :integer || @type == :float || @type == :string || @type == :symbol
            raise ValidationIncompatibleError
          end

          @not_in_validation = NotInValidation.new values
        end

        def validate_length maximum: nil, minimum: nil, is: nil
          if @length_validation
            raise ValidationAlreadyExistsError
          end

          unless @type == :string || @type == :symbol
            raise ValidationIncompatibleError
          end

          @length_validation = LengthValidation.new(maximum: maximum, minimum: minimum, is: is)
        end
      end
    end
  end
end
