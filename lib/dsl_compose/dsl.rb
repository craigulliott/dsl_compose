# frozen_string_literal: true

module DSLCompose
  class DSL

    def initialize name, &block
      @methods = {}
      @description = nil

      if name.kind_of? Symbol
        @name = name
      else
        raise Errors::InvalidName.new name
      end

      if block_given?
        self.instance_eval &block
      else
        warn "warning, no dsl block was provided for DSL #{name}"
      end
    end

    def get_name
      @name
    end

    def get_description
      @description
    end

    def get_dsl_methods
      @methods.values
    end

    def get_dsl_method name
      @methods[name]
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

      def add_method name, required: nil, &block
        if @methods.key? name
          raise Errors::MethodAlreadyExists.new(name)
        end

        @methods[name] = DSLMethod.new(name, false, required, &block)
      end

      def add_unique_method name, required: nil, &block
        if @methods.key? name
          raise Errors::MethodAlreadyExists.new(name)
        end

        @methods[name] = DSLMethod.new(name, true, required, &block)
      end

  end
end