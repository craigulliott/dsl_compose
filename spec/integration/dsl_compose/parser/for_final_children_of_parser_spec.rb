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

  it "successfully parses the DSL and returns child classes which are at the end of their anchestor chain whether the DSL was used on them or not" do
    child_classes = []
    TestParser.for_final_children_of BaseClass do |child_class:|
      child_classes << child_class
    end
    expect(child_classes).to eql([ChildClass2, GrandchildClass])
  end
end
