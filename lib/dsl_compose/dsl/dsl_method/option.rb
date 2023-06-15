# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Option

        def initialize name, required, type, &block
          @validations = {}
          @description = nil

          if name.kind_of? Symbol
            @name = name
          else
            raise Errors::InvalidName.new name
          end

          if type == :integer || type == :boolean || type == :float || type == :string || type == :symbol
            @type = type
          else
            raise Errors::InvalidType.new(type)
          end

          @required = required ? true : false

          if block_given?
            self.instance_eval &block
          end
        end

        def get_name
          @name
        end

        def get_description
          @description
        end

        def required?
          @required == true
        end

        def optional?
          @required == false
        end


        private

          def description description
            unless description.kind_of?(String) && description.length > 0
              raise Errors::InvalidDescription.new(description)
            end

            unless @description.nil?
              raise Errors::DescriptionAlreadyExists
            end

            @description = description
            end

          def add_validation name, value
            if @validations.key? name
              raise Errors::ValidationAlreadyExists.new(name)
            end

            @validations[name] = value
          end

          def validate_greater_than value
            unless value.kind_of?(Integer) || value.kind_of?(Float)
              raise Errors::ValidationInvalidOption.new("Invalid option type. #{value} was provided but Integer or Float was expected.")
            end

            unless @type == :integer || @type == :float
              raise Errors::ValidationIncompatible.new(:greater_than, @type)
            end

            add_validation :greater_than, value
          end

          def validate_greater_than_or_equal_to value
            unless value.kind_of?(Integer) || value.kind_of?(Float)
              raise Errors::ValidationInvalidOption.new("Invalid option type. #{value} was provided but Integer or Float was expected.")
            end

            unless @type == :integer || @type == :float
              raise Errors::ValidationIncompatible.new(:greater_than_or_equal_to, @type)
            end

            add_validation :greater_than_or_equal_to, value
          end

          def validate_less_than value
            unless value.kind_of?(Integer) || value.kind_of?(Float)
              raise Errors::ValidationInvalidOption.new("Invalid option type. #{value} was provided but Integer or Float was expected.")
            end

            unless @type == :integer || @type == :float
              raise Errors::ValidationIncompatible.new(:less_than, @type)
            end

            add_validation :less_than, value
          end

          def validate_less_than_or_equal_to value
            unless value.kind_of?(Integer) || value.kind_of?(Float)
              raise Errors::ValidationInvalidOption.new("Invalid option type. #{value} was provided but Integer or Float was expected.")
            end

            unless @type == :integer || @type == :float
              raise Errors::ValidationIncompatible.new(:less_than_or_equal_to, @type)
            end

            add_validation :less_than_or_equal_to, value
          end

          def validate_equal_to value
            unless @type == :integer || @type == :float || @type == :string || @type == :symbol || @type == :boolean
              raise Errors::ValidationIncompatible.new(:equal_to, @type)
            end

            add_validation :equal_to, value
          end

          def validate_length minimum: nil, maximum: nil, is: nil
            unless @type == :string || @type == :symbol
              raise Errors::ValidationIncompatible.new(:length, @type)
            end

            add_validation :length, value
          end

          def validate_not_in values
            unless regex.kind_of? Array
              raise Errors::ValidationInvalidOption.new("Invalid option type. #{values} was provided but Array was expected.")
            end

            unless @type == :integer || @type == :float || @type == :string || @type == :symbol
              raise Errors::ValidationIncompatible.new(:not_in, @type)
            end

            add_validation :not_in, value
          end

          def validate_in values
            unless values.kind_of? Array
              raise Errors::ValidationInvalidOption.new("Invalid option type. #{values} was provided but Array was expected.")
            end

            unless @type == :integer || @type == :float || @type == :string || @type == :symbol
              raise Errors::ValidationIncompatible.new(:in, @type)
            end

            add_validation :in, values
          end

          def validate_format regex
            unless regex.kind_of? Regexp
              raise Errors::ValidationInvalidOption.new("Invalid option type. #{regex} was provided but Regexp was expected.")
            end

            unless @type == :string || @type == :symbol
              raise Errors::ValidationIncompatible.new(:format, @type)
            end

            add_validation :format, regex
          end

      end
    end
  end
end