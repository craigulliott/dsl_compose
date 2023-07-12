# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser::ForDSLParser do
  let(:base_class) {
    Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :dsl_arg_name, :symbol
        requires :common_dsl_arg_name, :symbol
      end
      define_dsl :other_dsl_name do
        optional :common_dsl_arg_name, :symbol
      end
    end
  }
  let(:child_class1) { Class.new(base_class) }
  let(:child_class2) { Class.new(base_class) }
  let(:parser) { Class.new(DSLCompose::Parser) }

  describe "for the same DSL used on two different child classes" do
    before(:each) do
      child_class1.dsl_name :foo1, :bar
      child_class2.dsl_name :foo2, :bar
    end

    it "parses for each use of the DSL" do
      child_classes = []
      dsl_names = []
      dsl_arg_names = []
      parser.for_children_of base_class do |child_class:|
        child_classes << child_class
        for_dsl :dsl_name do |dsl_name:, dsl_arg_name:|
          dsl_names << dsl_name
          dsl_arg_names << dsl_arg_name
        end
      end
      expect(child_classes).to eql([child_class1, child_class2])
      expect(dsl_names).to eql([:dsl_name, :dsl_name])
      expect(dsl_arg_names).to eql([:foo1, :foo2])
    end
  end

  describe "for the same DSL used twice on the same child class" do
    before(:each) do
      child_class1.dsl_name :foo1, :bar
      child_class1.dsl_name :foo2, :bar
    end

    it "parses for each use of the DSL" do
      child_classes = []
      dsl_names = []
      dsl_arg_names = []
      parser.for_children_of base_class do |child_class:|
        child_classes << child_class
        for_dsl :dsl_name do |dsl_name:, dsl_arg_name:|
          dsl_names << dsl_name
          dsl_arg_names << dsl_arg_name
        end
      end
      expect(child_classes).to eql([child_class1])
      expect(dsl_names).to eql([:dsl_name, :dsl_name])
      expect(dsl_arg_names).to eql([:foo1, :foo2])
    end
  end

  describe "for different DSLs used on the same child class" do
    before(:each) do
      child_class1.dsl_name :foo1, :bar
      child_class1.other_dsl_name common_dsl_arg_name: :foo2
    end

    it "accepts an array of DSL names and parses for each use of the DSL and any common DSL parameters" do
      child_classes = []
      dsl_names = []
      dsl_arg_names = []
      parser.for_children_of base_class do |child_class:|
        child_classes << child_class
        for_dsl [:dsl_name, :other_dsl_name] do |dsl_name:, common_dsl_arg_name:|
          dsl_names << dsl_name
          dsl_arg_names << common_dsl_arg_name
        end
      end
      expect(child_classes).to eql([child_class1])
      expect(dsl_names).to eql([:dsl_name, :other_dsl_name])
      expect(dsl_arg_names).to eql([:bar, :foo2])
    end
  end

  describe "for different DSLs used on differnet child classes" do
    before(:each) do
      child_class1.dsl_name :foo1, :bar
      child_class2.other_dsl_name common_dsl_arg_name: :foo2
    end

    it "accepts an array of DSL names and parses for each use of the DSL and any common DSL parameters" do
      child_classes = []
      dsl_names = []
      dsl_arg_names = []
      parser.for_children_of base_class do |child_class:|
        child_classes << child_class
        for_dsl [:dsl_name, :other_dsl_name] do |dsl_name:, common_dsl_arg_name:|
          dsl_names << dsl_name
          dsl_arg_names << common_dsl_arg_name
        end
      end
      expect(child_classes).to eql([child_class1, child_class2])
      expect(dsl_names).to eql([:dsl_name, :other_dsl_name])
      expect(dsl_arg_names).to eql([:bar, :foo2])
    end

    it "raises an error if trying to access an argument name which is not shared between both DSLs" do
      expect {
        parser.for_children_of base_class do |child_class:|
          for_dsl [:dsl_name, :other_dsl_name] do |dsl_name:, dsl_arg_name:|
          end
        end
      }.to raise_error ArgumentError
    end
  end
end
