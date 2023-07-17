# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser::ForDSLParser do
  before(:each) do
    create_class :BaseClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :dsl_arg_name, :symbol, array: true
        requires :common_dsl_arg_name, :symbol
      end
      define_dsl :other_dsl_name do
        optional :common_dsl_arg_name, :symbol
      end
    end

    create_class :ChildClass1, BaseClass
    create_class :ChildClass2, BaseClass
    create_class :GrandchildClass, ChildClass1

    create_class :TestParser, DSLCompose::Parser
  end

  describe "for the same DSL used on two different child classes" do
    before(:each) do
      ChildClass1.dsl_name :foo1, :bar
      ChildClass2.dsl_name :foo2, :bar
    end

    it "parses for each use of the DSL, and once more for GrandchildClass which extends ChildClass1" do
      child_classes = []
      dsl_names = []
      dsl_arg_names = []
      TestParser.for_children_of BaseClass do |child_class:|
        child_classes << child_class
        for_dsl_or_inherited_dsl :dsl_name do |dsl_name:, dsl_arg_name:|
          dsl_names << dsl_name
          dsl_arg_names << dsl_arg_name
        end
      end
      expect(child_classes.sort_by(&:name)).to eql([ChildClass1, ChildClass2, GrandchildClass])
      expect(dsl_names).to eql([:dsl_name, :dsl_name, :dsl_name])
      expect(dsl_arg_names).to eql([[:foo1], [:foo2], [:foo1]])
    end
  end

  describe "for the same DSL used twice on the same child class" do
    before(:each) do
      ChildClass1.dsl_name :foo1, :bar
      ChildClass1.dsl_name :foo2, :bar
    end

    it "parses for each use of the DSL, and twice more for GrandchildClass which extends ChildClass1" do
      child_classes = []
      dsl_names = []
      dsl_arg_names = []
      TestParser.for_children_of BaseClass do |child_class:|
        child_classes << child_class
        for_dsl_or_inherited_dsl :dsl_name do |dsl_name:, dsl_arg_name:|
          dsl_names << dsl_name
          dsl_arg_names << dsl_arg_name
        end
      end
      expect(child_classes.sort_by(&:name)).to eql([ChildClass1, ChildClass2, GrandchildClass])
      expect(dsl_names).to eql([:dsl_name, :dsl_name, :dsl_name, :dsl_name])
      expect(dsl_arg_names).to eql([[:foo1], [:foo2], [:foo1], [:foo2]])
    end
  end

  describe "for different DSLs used on the same child class" do
    before(:each) do
      ChildClass1.dsl_name :foo1, :bar
      ChildClass1.other_dsl_name common_dsl_arg_name: :foo2
    end

    it "accepts an array of DSL names and parses for each use of the DSL and any common DSL parameters, and again for GrandchildClass which extends ChildClass1" do
      child_classes = []
      dsl_names = []
      dsl_arg_names = []
      TestParser.for_children_of BaseClass do |child_class:|
        child_classes << child_class
        for_dsl_or_inherited_dsl [:dsl_name, :other_dsl_name] do |dsl_name:, common_dsl_arg_name:|
          dsl_names << dsl_name
          dsl_arg_names << common_dsl_arg_name
        end
      end
      expect(child_classes.sort_by(&:name)).to eql([ChildClass1, ChildClass2, GrandchildClass])
      expect(dsl_names).to eql([:dsl_name, :other_dsl_name, :dsl_name, :other_dsl_name])
      expect(dsl_arg_names).to eql([:bar, :foo2, :bar, :foo2])
    end
  end

  describe "for different DSLs used on differnet child classes" do
    before(:each) do
      ChildClass1.dsl_name :foo1, :bar
      ChildClass2.other_dsl_name common_dsl_arg_name: :foo2
    end

    it "accepts an array of DSL names and parses for each use of the DSL and any common DSL parameters, and once more for GrandchildClass which extends ChildClass1" do
      child_classes = []
      dsl_names = []
      dsl_arg_names = []
      TestParser.for_children_of BaseClass do |child_class:|
        child_classes << child_class
        for_dsl_or_inherited_dsl [:dsl_name, :other_dsl_name] do |dsl_name:, common_dsl_arg_name:|
          dsl_names << dsl_name
          dsl_arg_names << common_dsl_arg_name
        end
      end
      expect(child_classes.sort_by(&:name)).to eql([ChildClass1, ChildClass2, GrandchildClass])
      expect(dsl_names).to eql([:dsl_name, :other_dsl_name, :dsl_name])
      expect(dsl_arg_names).to eql([:bar, :foo2, :bar])
    end

    it "raises an error if trying to access an argument name which is not shared between both DSLs" do
      expect {
        TestParser.for_children_of BaseClass do |child_class:|
          for_dsl_or_inherited_dsl [:dsl_name, :other_dsl_name] do |dsl_name:, dsl_arg_name:|
          end
        end
      }.to raise_error ArgumentError
    end
  end

  describe "for a DSL which accepts a class" do
    before(:each) do
      create_class :BaseClassWhichAcceptsAClassArgument do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          requires :dsl_arg_name, :class
        end
      end

      create_class :ChildOfBaseClassWhichAcceptsAClassArgument, BaseClassWhichAcceptsAClassArgument
      ChildOfBaseClassWhichAcceptsAClassArgument.dsl_name "Integer"
    end

    it "parses the DSL and provides the actual class, not the name, in the parse result" do
      child_classes = []
      dsl_names = []
      dsl_args = []
      TestParser.for_children_of BaseClassWhichAcceptsAClassArgument do |child_class:|
        child_classes << child_class
        for_dsl_or_inherited_dsl :dsl_name do |dsl_name:, dsl_arg_name:|
          dsl_names << dsl_name
          dsl_args << dsl_arg_name
        end
      end
      expect(child_classes).to eql([ChildOfBaseClassWhichAcceptsAClassArgument])
      expect(dsl_names).to eql([:dsl_name])
      expect(dsl_args).to eql([Integer])
    end
  end
end
