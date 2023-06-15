# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument

        class ValidationInvalidArgumentError < StandardError
        end

        class ValidationIncompatibleError < StandardError
          def message
            super "The validation is not compatible with this argument type"
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

        attr_reader :name
        attr_reader :type
        attr_reader :required
        attr_reader :description

        def initialize name, required, type, &block
          @validations = {}

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

          if block
            Interpreter.new(self).instance_eval(&block)
          end
        end

        def set_description description
          unless description.is_a?(String) && description.length > 0
            raise InvalidDescriptionError
          end

          if has_description?
            raise DescriptionAlreadyExistsError
          end

          @description = description
        end

        def validations
          @validations.values
        end

        def required?
          @required == true
        end

        def optional?
          @required == false
        end

        def add_validation name, value
          if @validations.key? name
            raise ValidationAlreadyExistsError
          end

          if [:greater_than, :greater_than_or_equal_to, :less_than, :less_than_or_equal_to].include? name
            unless value.is_a?(Integer) || value.is_a?(Float)
              raise ValidationInvalidArgumentError
            end

            unless @type == :integer || @type == :float
              raise ValidationIncompatibleError
            end
          end

          if name == :equal_to
            unless @type == :integer || @type == :float || @type == :string || @type == :symbol || @type == :boolean
              raise ValidationIncompatibleError
            end
          end

          if name == :length
            unless @type == :string || @type == :symbol
              raise ValidationIncompatibleError
            end
          end

          if [:not_in, :in].include? name
            unless values.is_a? Array
              raise ValidationInvalidArgumentError
            end

            unless @type == :integer || @type == :float || @type == :string || @type == :symbol
              raise ValidationIncompatibleError
            end
          end

          if name == :format
            unless regex.is_a? Regexp
              raise ValidationInvalidArgumentError
            end

            unless @type == :string || @type == :symbol
              raise ValidationIncompatibleError
            end
          end

          @validations[name] = value
        end
      end
    end
  end
end
