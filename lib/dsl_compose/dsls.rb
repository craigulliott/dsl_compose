# frozen_string_literal: true

module DSLCompose
  module DSLs
    @dsls = {}

    def self.create_dsl klass, name, &block
      @dsls[klass] ||= {}

      if @dsls[klass].key? name
        raise Errors::DSLAlreadyExists.new name
      end

      @dsls[klass][name] = DSLCompose::DSL.new(name, &block)
    end

    def self.dsls
      @dsls
    end

    def self.get_class_dsls klass
      @dsls[klass]
    end

    def self.get_class_dsl klass, name
      @dsls[klass] && @dsls[klass][name] || nil
    end

    def self.reset
      @dsls = {}
    end
  end
end
