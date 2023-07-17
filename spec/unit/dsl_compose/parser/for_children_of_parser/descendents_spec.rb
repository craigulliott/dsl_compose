# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser::Descendents do
  before(:each) do
    # note, these are deliberately created in a non natural order, so we can
    # properly test the sorting
    create_class "BaseClass3"
    create_class "BaseClass1"
    create_class "BaseClass2"

    create_class "BaseClass1::Child1", BaseClass1

    create_class "BaseClass1::Child1::Grandchild1", BaseClass1::Child1

    create_class "BaseClass2::Child1", BaseClass2

    create_class "BaseClass1::Child2", BaseClass1

    create_class "BaseClass3::Child1", BaseClass3

    create_class "BaseClass1::Child2::Grandchild2", BaseClass1::Child2

    create_class "BaseClass1::Child2::Grandchild1", BaseClass1::Child2

    create_class "BaseClass1::Child2::Grandchild2::GreatGrandhild1", BaseClass1::Child2::Grandchild2
  end

  describe :initialize do
    it "initializes the class without error" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::Descendents.new BaseClass1, true
      }.to_not raise_error
    end
  end

  describe :classes do
    describe "when final_children_only is true" do
      let(:descendants) { DSLCompose::Parser::ForChildrenOfParser::Descendents.new BaseClass1, true }

      it "returns the expected classes in the expected order" do
        expect(descendants.classes).to eql([
          BaseClass1::Child1::Grandchild1,
          BaseClass1::Child2::Grandchild1,
          BaseClass1::Child2::Grandchild2::GreatGrandhild1
        ])
      end
    end

    describe "when final_children_only is false" do
      let(:descendants) { DSLCompose::Parser::ForChildrenOfParser::Descendents.new BaseClass1, false }

      it "returns the expected classes in the expected order" do
        expect(descendants.classes).to eql([
          BaseClass1::Child1,
          BaseClass1::Child2,
          BaseClass1::Child1::Grandchild1,
          BaseClass1::Child2::Grandchild1,
          BaseClass1::Child2::Grandchild2,
          BaseClass1::Child2::Grandchild2::GreatGrandhild1
        ])
      end
    end
  end
end
