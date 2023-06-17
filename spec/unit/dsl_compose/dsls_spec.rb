# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSLs do
  let(:dummy_class) { Class.new }

  describe :create_dsl do
    it "creates a new DSL without raising any errors" do
      DSLCompose::DSLs.create_dsl dummy_class, :dsl_name
    end

    describe "if a DSL with the same name has already been added for this class" do
      before(:each) do
        DSLCompose::DSLs.create_dsl dummy_class, :dsl_name
      end

      it "raises an error" do
        expect {
          DSLCompose::DSLs.create_dsl dummy_class, :dsl_name
        }.to raise_error(DSLCompose::DSLs::DSLAlreadyExistsError)
      end
    end
  end

  describe :dsls do
    it "returns an empty object" do
      expect(DSLCompose::DSLs.dsls).to be_kind_of Hash
      expect(DSLCompose::DSLs.dsls).to be_empty
    end

    describe "after a dsl has been added" do
      let(:dsl) { DSLCompose::DSLs.create_dsl dummy_class, :dsl_name }

      before(:each) do
        dsl
      end

      it "returns an object which contains the DSL" do
        expect(DSLCompose::DSLs.dsls).to be_kind_of Hash
        expect(DSLCompose::DSLs.dsls).to have_key(dummy_class)
        expect(DSLCompose::DSLs.dsls[dummy_class]).to have_key(:dsl_name)
        expect(DSLCompose::DSLs.dsls[dummy_class][:dsl_name]).to be(dsl)
      end
    end
  end

  describe :class_dsls do
    it "raises an error" do
      expect {
        DSLCompose::DSLs.class_dsls dummy_class
      }.to raise_error(DSLCompose::DSLs::NoDSLDefinitionsForClassError)
    end

    describe "after a dsl has been added" do
      let(:dsl) { DSLCompose::DSLs.create_dsl dummy_class, :dsl_name }

      before(:each) do
        dsl
      end

      it "returns an array of this classes DSLs" do
        expect(DSLCompose::DSLs.class_dsls(dummy_class)).to be_kind_of Array
        expect(DSLCompose::DSLs.class_dsls(dummy_class).count).to eq(1)
        expect(DSLCompose::DSLs.class_dsls(dummy_class).first).to be(dsl)
      end
    end
  end

  describe :class_dsl do
    it "raises an error" do
      expect {
        DSLCompose::DSLs.class_dsls dummy_class
      }.to raise_error(DSLCompose::DSLs::NoDSLDefinitionsForClassError)
    end

    describe "after a dsl has been added" do
      let(:dsl) { DSLCompose::DSLs.create_dsl dummy_class, :dsl_name }

      before(:each) do
        dsl
      end

      it "returns an array of this classes DSLs" do
        expect(DSLCompose::DSLs.class_dsls(dummy_class)).to be_kind_of Array
        expect(DSLCompose::DSLs.class_dsls(dummy_class).count).to eq(1)
        expect(DSLCompose::DSLs.class_dsls(dummy_class).first).to be(dsl)
      end
    end
  end

  describe :reset do
    describe "after a dsl has been added" do
      let(:dsl) { DSLCompose::DSLs.create_dsl dummy_class, :dsl_name }

      before(:each) do
        dsl
      end

      describe "after reset has been called" do
        before(:each) do
          DSLCompose::DSLs.reset
        end

        describe :dsls do
          it "returns an empty object" do
            expect(DSLCompose::DSLs.dsls).to be_kind_of Hash
            expect(DSLCompose::DSLs.dsls).to be_empty
          end
        end
      end
    end
  end
end
