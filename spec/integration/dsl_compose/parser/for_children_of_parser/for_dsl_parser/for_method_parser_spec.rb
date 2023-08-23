# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser do
  before(:each) do
    create_class :BaseClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :method_arg_name, :symbol
          optional :common_method_arg_name, :boolean
        end
        add_method :common_method_name do
          requires :other_method_arg_name, :symbol
          optional :common_method_arg_name, :boolean
        end
      end
      define_dsl :other_dsl_name do
        add_method :other_method_name do
          # no args
        end
        add_method :common_method_name do
          requires :common_method_arg_name, :symbol
        end
      end
    end

    create_class :ChildClass1, BaseClass
    create_class :ChildClass2, BaseClass

    create_class :TestParser, DSLCompose::Parser
  end

  describe "where a DSL with a method, has the method called once" do
    before(:each) do
      ChildClass1.dsl_name do
        method_name :foo, common_method_arg_name: true
      end
    end

    it "adds a parser note for the dsl method with the dsl method args" do
      TestParser.for_children_of BaseClass do |child_class:|
        for_dsl :dsl_name do |dsl_name:|
          for_method :method_name do |method_name:, method_arg_name:, common_method_arg_name:|
            description <<~DESCRIPTION
              Notes on what this parser is doing, this is used for generating documentation
            DESCRIPTION
          end
        end
      end
      expect(BaseClass.dsls.class_executions(ChildClass1).first.method_calls.method_calls.first.parser_usage_notes).to eql(["Notes on what this parser is doing, this is used for generating documentation"])
    end
  end

  describe "where a DSL with a method, has the method called once without providing a value to an optional boolean arguent" do
    before(:each) do
      ChildClass1.dsl_name do
        method_name :foo
      end
    end

    it "returns false instead of nil for the optional boolean argument which was not used" do
      bool_value = nil
      TestParser.for_children_of BaseClass do |child_class:|
        for_dsl :dsl_name do |dsl_name:|
          for_method :method_name do |common_method_arg_name:|
            bool_value = common_method_arg_name
          end
        end
      end
      expect(bool_value).to be false
    end
  end

  describe "where a DSL is used three times, but a method is only called once" do
    before(:each) do
      ChildClass1.dsl_name
      ChildClass1.dsl_name
      ChildClass1.dsl_name do
        method_name :foo, common_method_arg_name: true
      end
      ChildClass1.dsl_name
    end

    it "parses for each use of the DSL, but only once for the dsl method with the dsl method args" do
      child_classes = []
      method_names = []
      dsl_names = []
      method_arg_names = []
      common_method_arg_names = []
      TestParser.for_children_of BaseClass do |child_class:|
        child_classes << child_class
        for_dsl :dsl_name do |dsl_name:|
          dsl_names << dsl_name
          for_method :method_name do |method_name:, method_arg_name:, common_method_arg_name:|
            method_names << method_name
            method_arg_names << method_arg_name
            common_method_arg_names << common_method_arg_name
          end
        end
      end
      expect(child_classes.sort_by(&:name)).to eql([ChildClass1, ChildClass2])
      expect(method_names).to eql([:method_name])
      expect(method_arg_names).to eql([:foo])
      expect(common_method_arg_names).to eql([true])
      expect(dsl_names).to eql([:dsl_name, :dsl_name, :dsl_name, :dsl_name])
    end
  end

  describe "where a DSL method is used twice from the same DSL on the same child class" do
    before(:each) do
      ChildClass1.dsl_name do
        method_name :foo1, common_method_arg_name: true
      end
      ChildClass1.dsl_name do
        method_name :foo2, common_method_arg_name: true
      end
    end

    it "parses for each use of the DSL method" do
      child_classes = []
      method_names = []
      dsl_names = []
      method_arg_names = []
      common_method_arg_names = []
      TestParser.for_children_of BaseClass do |child_class:|
        child_classes << child_class
        for_dsl :dsl_name do |dsl_name:|
          dsl_names << dsl_name
          for_method :method_name do |method_name:, method_arg_name:, common_method_arg_name:|
            method_names << method_name
            method_arg_names << method_arg_name
            common_method_arg_names << common_method_arg_name
          end
        end
      end
      expect(child_classes.sort_by(&:name)).to eql([ChildClass1, ChildClass2])
      expect(method_names).to eql([:method_name, :method_name])
      expect(method_arg_names).to eql([:foo1, :foo2])
      expect(common_method_arg_names).to eql([true, true])
      expect(dsl_names).to eql([:dsl_name, :dsl_name])
    end
  end

  describe "where a DSL method with the same name is used from two different DSLs on the same child class" do
    before(:each) do
      ChildClass1.dsl_name do
        common_method_name :foo1, common_method_arg_name: true
      end
      ChildClass1.other_dsl_name do
        common_method_name :foo2
      end
    end

    it "parses for each use of the DSL method" do
      child_classes = []
      method_names = []
      dsl_names = []
      common_method_arg_names = []
      TestParser.for_children_of BaseClass do |child_class:|
        child_classes << child_class
        for_dsl [:dsl_name, :other_dsl_name] do |dsl_name:|
          dsl_names << dsl_name
          for_method :common_method_name do |method_name:, common_method_arg_name:|
            method_names << method_name
            common_method_arg_names << common_method_arg_name
          end
        end
      end
      expect(child_classes.sort_by(&:name)).to eql([ChildClass1, ChildClass2])
      expect(method_names).to eql([:common_method_name, :common_method_name])
      expect(common_method_arg_names).to eql([true, :foo2])
      expect(dsl_names).to eql([:dsl_name, :other_dsl_name])
    end
  end

  describe "where a DSL method with the same name is used from two different DSLs on different child classes" do
    before(:each) do
      ChildClass1.dsl_name do
        common_method_name :foo1, common_method_arg_name: true
      end
      ChildClass2.other_dsl_name do
        common_method_name :foo2
      end
    end

    it "parses for each use of the DSL method" do
      child_classes = []
      method_names = []
      dsl_names = []
      common_method_arg_names = []
      TestParser.for_children_of BaseClass do |child_class:|
        child_classes << child_class
        for_dsl [:dsl_name, :other_dsl_name] do |dsl_name:|
          dsl_names << dsl_name
          for_method :common_method_name do |method_name:, common_method_arg_name:|
            method_names << method_name
            common_method_arg_names << common_method_arg_name
          end
        end
      end
      expect(child_classes.sort_by(&:name)).to eql([ChildClass1, ChildClass2])
      expect(method_names).to eql([:common_method_name, :common_method_name])
      expect(common_method_arg_names).to eql([true, :foo2])
      expect(dsl_names).to eql([:dsl_name, :other_dsl_name])
    end
  end
end
