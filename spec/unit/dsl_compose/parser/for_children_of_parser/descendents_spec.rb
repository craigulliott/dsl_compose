# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser::Descendents do
  before(:each) do
    # note, these are deliberately created in a non natural order, so we can
    # properly test the sorting
    create_class "BaseClass"

    create_class "BaseClass3", BaseClass
    create_class "BaseClass1", BaseClass
    create_class "BaseClass2", BaseClass

    create_class "BaseClass1::Child1", BaseClass
    create_class "BaseClass1::Adult1", BaseClass
    create_class "BaseClass1::Admin1", BaseClass1::Adult1

    create_class "BaseClass1::Child1::Grandchild1", BaseClass

    create_class "BaseClass2::Child1", BaseClass

    create_class "BaseClass1::Child2", BaseClass

    create_class "BaseClass3::Child1", BaseClass

    create_class "BaseClass1::Child2::Grandchild2", BaseClass

    create_class "BaseClass1::Child2::Grandchild1", BaseClass

    create_class "BaseClass1::Child2::Grandchild2::GreatGrandhild1", BaseClass
  end

  describe :initialize do
    it "initializes the class without error" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::Descendents.new BaseClass, true
      }.to_not raise_error
    end
  end

  describe :classes do
    describe "when final_children_only is true" do
      let(:descendants) { DSLCompose::Parser::ForChildrenOfParser::Descendents.new BaseClass, true }

      it "returns the expected classes in the expected order" do
        expect(descendants.classes).to eql([
          BaseClass1,
          BaseClass2,
          BaseClass3,
          BaseClass1::Admin1,
          BaseClass1::Child1,
          BaseClass1::Child2,
          BaseClass2::Child1,
          BaseClass3::Child1,
          BaseClass1::Child1::Grandchild1,
          BaseClass1::Child2::Grandchild1,
          BaseClass1::Child2::Grandchild2,
          BaseClass1::Child2::Grandchild2::GreatGrandhild1
        ])
      end

      describe "when skipping certain classes" do
        let(:descendants) { DSLCompose::Parser::ForChildrenOfParser::Descendents.new BaseClass, true, ["BaseClass1::Admin1"] }

        it "returns the expected classes in the expected order" do
          expect(descendants.classes).to eql([
            BaseClass1,
            BaseClass2,
            BaseClass3,
            BaseClass1::Child1,
            BaseClass1::Child2,
            BaseClass2::Child1,
            BaseClass3::Child1,
            BaseClass1::Child1::Grandchild1,
            BaseClass1::Child2::Grandchild1,
            BaseClass1::Child2::Grandchild2,
            BaseClass1::Child2::Grandchild2::GreatGrandhild1
          ])
        end
      end
    end

    describe "when final_children_only is false" do
      let(:descendants) { DSLCompose::Parser::ForChildrenOfParser::Descendents.new BaseClass, false }

      it "returns the expected classes in the expected order" do
        expect(descendants.classes).to eql([
          BaseClass1,
          BaseClass2,
          BaseClass3,
          # note that Adult normally comes after Admin (alphabetically), but
          # because Admin is a child of Adult (Adult has dependencies), it
          # comes first
          BaseClass1::Adult1,
          BaseClass1::Admin1,
          BaseClass1::Child1,
          BaseClass1::Child2,
          BaseClass2::Child1,
          BaseClass3::Child1,
          BaseClass1::Child1::Grandchild1,
          BaseClass1::Child2::Grandchild1,
          BaseClass1::Child2::Grandchild2,
          BaseClass1::Child2::Grandchild2::GreatGrandhild1
        ])
      end

      describe "when skipping certain classes" do
        let(:descendants) { DSLCompose::Parser::ForChildrenOfParser::Descendents.new BaseClass, false, ["BaseClass1::Adult1", "BaseClass1::Admin1"] }

        it "returns the expected classes in the expected order" do
          expect(descendants.classes).to eql([
            BaseClass1,
            BaseClass2,
            BaseClass3,
            BaseClass1::Child1,
            BaseClass1::Child2,
            BaseClass2::Child1,
            BaseClass3::Child1,
            BaseClass1::Child1::Grandchild1,
            BaseClass1::Child2::Grandchild1,
            BaseClass1::Child2::Grandchild2,
            BaseClass1::Child2::Grandchild2::GreatGrandhild1
          ])
        end
      end
    end
  end
end
