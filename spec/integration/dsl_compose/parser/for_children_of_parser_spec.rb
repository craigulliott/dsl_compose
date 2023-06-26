# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser do
  let(:base_class) {
    Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
      end
    end
  }
  let(:child_class1) { Class.new(base_class) }
  let(:child_class2) { Class.new(base_class) }
  let(:parser) { Class.new(DSLCompose::Parser) }

  describe "for a DSL used on two child classes" do
    before(:each) do
      child_class1.dsl_name
      child_class2.dsl_name
    end

    it "successfully parses the DSL and returns each child class" do
      child_classes = []
      parser.for_children_of base_class do |child_class:|
        child_classes << child_class
      end
      expect(child_classes).to eql([child_class1, child_class2])
    end
  end

  describe "for the same DSL used twice on a child class" do
    before(:each) do
      child_class1.dsl_name
      child_class1.dsl_name
    end

    it "parses only once per child class" do
      child_classes = []
      parser.for_children_of base_class do |child_class:|
        child_classes << child_class
      end
      expect(child_classes).to eql([child_class1])
    end
  end
end
