# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser do
  before(:each) do
    create_class :BaseClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
      end
    end

    create_class :ChildClass1, BaseClass
    create_class :ChildClass2, BaseClass
    create_class :GrandchildClass, ChildClass1

    create_class :TestParser, DSLCompose::Parser
  end

  it "successfully parses the DSL and returns each child class whether the DSL was used or not" do
    child_classes = []
    TestParser.for_children_of BaseClass do |child_class:|
      child_classes << child_class
    end
    expect(child_classes.sort_by(&:name)).to eql([ChildClass1, ChildClass2, GrandchildClass])
  end

  it "successfully parses the DSL and adds a parser note" do
    TestParser.for_children_of BaseClass do |child_class:|
      add_documentation <<~DOCS
        Notes on what this parser is doing, this is used for generating documentation
      DOCS
    end
    expect(BaseClass.dsls.parser_usage_notes(ChildClass1)).to eql(["Notes on what this parser is doing, this is used for generating documentation"])
    expect(BaseClass.dsls.parser_usage_notes(ChildClass2)).to eql(["Notes on what this parser is doing, this is used for generating documentation"])
    expect(BaseClass.dsls.parser_usage_notes(GrandchildClass)).to eql(["Notes on what this parser is doing, this is used for generating documentation"])
  end
end
