# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      def initialize name, unique, required, &block
        @options = {}
        @description = nil

        if name.is_a? Symbol
          @name = name
        else
          raise Errors::InvalidName.new name
        end

        @unique = unique ? true : false
        @required = required ? true : false

        if block
          instance_eval(&block)
        end
      end

      def get_name
        @name
      end

      def get_description
        @description
      end

      def get_options
        @options.values
      end

      def unique?
        @unique == true
      end

      def required?
        @required == true
      end

      private

      def description description
        unless description.is_a?(String) && description.length > 0
          raise Errors::InvalidDescription.new(description)
        end

        unless @description.nil?
          raise Errors::DescriptionAlreadyExists
        end

        @description = description
      end

      def optional name, type, &block
        option false, name, type, &block
      end

      def requires name, type, &block
        # required options may not come after optional ones
        if @options.values.any?(&:optional?)
          raise Errors::OptionOrdering
        end

        option true, name, type, &block
      end

      def option required, name, type, &block
        if @options.key? name
          raise Errors::OptionAlreadyExists.new(name)
        end

        @options[name] = Option.new(name, required, type, &block)
      end
    end
  end
end
