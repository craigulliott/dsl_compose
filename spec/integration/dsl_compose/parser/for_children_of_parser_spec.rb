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
    expect(child_classes).to eql([GrandchildClass, ChildClass2, ChildClass1])
  end
end
