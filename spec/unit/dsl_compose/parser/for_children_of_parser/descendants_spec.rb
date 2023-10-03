# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser::Descendants do
  before(:each) do
    # note, these are deliberately created in a non natural order, so we can
    # properly test the sorting
    create_class "BaseClass"

    create_class "BaseClass3", BaseClass
    create_class "BaseClass1", BaseClass
    create_class "BaseClass2", BaseClass

    create_class "BaseClass1::Child1", BaseClass1
    create_class "BaseClass1::Adult1", BaseClass1
    create_class "BaseClass1::Admin1", BaseClass1::Adult1

    create_class "BaseClass1::Child1::Grandchild1", BaseClass1::Child1

    create_class "BaseClass2::Child1", BaseClass2

    create_class "BaseClass1::Child2", BaseClass1

    create_class "BaseClass3::Child1", BaseClass3

    create_class "BaseClass1::Child2::Grandchild2", BaseClass1::Child2

    create_class "BaseClass1::Child2::Grandchild1", BaseClass1::Child2

    create_class "BaseClass1::Child2::Grandchild2::GreatGrandChild1", BaseClass1::Child2::Grandchild2
  end

  describe :initialize do
    it "initializes the class without error" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::Descendants.new BaseClass, true
      }.to_not raise_error
    end
  end

  describe :classes do
    describe "when final_children_only is true" do
      let(:descendants) { DSLCompose::Parser::ForChildrenOfParser::Descendants.new BaseClass, true }

      it "returns the expected classes in the expected order" do
        expect(descendants.classes).to eql([
          BaseClass1::Admin1,
          BaseClass1::Child1::Grandchild1,
          BaseClass1::Child2::Grandchild1,
          BaseClass1::Child2::Grandchild2::GreatGrandChild1,
          BaseClass2::Child1,
          BaseClass3::Child1
        ])
      end

      describe "when skipping certain classes" do
        let(:descendants) { DSLCompose::Parser::ForChildrenOfParser::Descendants.new BaseClass, true, ["BaseClass2::Child1"] }

        it "returns the expected classes in the expected order" do
          expect(descendants.classes).to eql([
            BaseClass1::Admin1,
            BaseClass1::Child1::Grandchild1,
            BaseClass1::Child2::Grandchild1,
            BaseClass1::Child2::Grandchild2::GreatGrandChild1,
            BaseClass3::Child1
          ])
        end
      end
    end

    describe "when final_children_only is false" do
      let(:descendants) { DSLCompose::Parser::ForChildrenOfParser::Descendants.new BaseClass, false }

      it "returns the expected classes in the expected order" do
        expect(descendants.classes).to eql([
          BaseClass1,
          BaseClass1::Adult1,
          BaseClass1::Admin1,
          BaseClass1::Child1,
          BaseClass1::Child1::Grandchild1,
          BaseClass1::Child2,
          BaseClass1::Child2::Grandchild1,
          BaseClass1::Child2::Grandchild2,
          BaseClass1::Child2::Grandchild2::GreatGrandChild1,
          BaseClass2,
          BaseClass2::Child1,
          BaseClass3,
          BaseClass3::Child1
        ])
      end

      describe "when skipping certain classes" do
        let(:descendants) { DSLCompose::Parser::ForChildrenOfParser::Descendants.new BaseClass, false, ["BaseClass1::Adult1", "BaseClass1::Child2::Grandchild2"] }

        it "returns the expected classes in the expected order" do
          expect(descendants.classes).to eql([
            BaseClass1,
            BaseClass1::Admin1,
            BaseClass1::Child1,
            BaseClass1::Child1::Grandchild1,
            BaseClass1::Child2,
            BaseClass1::Child2::Grandchild1,
            BaseClass1::Child2::Grandchild2::GreatGrandChild1,
            BaseClass2,
            BaseClass2::Child1,
            BaseClass3,
            BaseClass3::Child1
          ])
        end
      end
    end
  end
end
