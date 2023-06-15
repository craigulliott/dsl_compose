# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod

      class InvalidNameError < StandardError
        def message
          "The method #{method_name} is invalid, it must be of type symbol"
        end
      end

      class InvalidDescriptionError < StandardError
        def message
          "The DSL method description is invalid, it must be of type string and have length greater than 0"
        end
      end

      class DescriptionAlreadyExistsError < StandardError
        def message
          "The description has already been set"
        end
      end

      class ArgumentOrderingError < StandardError
        def message
          "Required arguments can not be added after optional ones"
        end
      end

      class ArgumentAlreadyExistsError < StandardError
        def message
          "An argument with this name already exists for this DSL method"
        end
      end

      attr_reader :name
      attr_reader :unique
      attr_reader :required
      attr_reader :description

      def initialize name, unique, required, &block
        @arguments = {}

        if name.is_a? Symbol
          @name = name
        else
          raise InvalidNameError
        end

        @unique = unique ? true : false
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

      def arguments
        @arguments.values
      end

      def optional_arguments
        arguments.filter(&:optional?)
      end

      def required_arguments
        arguments.filter(&:required?)
      end

      def has_description?
        @description.nil? == false
      end

      def unique?
        @unique == true
      end

      def required?
        @required == true
      end

      def optional?
        @required == false
      end

      def add_argument name, required, type, &block
        if @arguments.key? name
          raise ArgumentAlreadyExistsError
        end

        # required arguments may not come after optional ones
        if required && optional_arguments.any?
          raise ArgumentOrderingError
        end

        @arguments[name] = Argument.new(name, required, type, &block)
      end
    end
  end
end
