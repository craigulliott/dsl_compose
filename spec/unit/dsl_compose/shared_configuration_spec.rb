# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::SharedConfiguration do
  let(:dummy_proc) { proc {} }

  describe :add do
    it "takes a provided name and proc and stores it" do
      DSLCompose::SharedConfiguration.add :name, &dummy_proc
      expect(DSLCompose::SharedConfiguration.get(:name)).to be(dummy_proc)
    end

    describe "where a block with this name already exists" do
      before(:each) do
        DSLCompose::SharedConfiguration.add :name, &dummy_proc
      end

      it "raises an error" do
        expect {
          DSLCompose::SharedConfiguration.add :name, &dummy_proc
        }.to raise_error(DSLCompose::SharedConfiguration::SharedConfigurationAlreadyExistsError)
      end
    end
  end

  describe :get do
    it "raises an error because this proc does not exist" do
      expect {
        DSLCompose::SharedConfiguration.get :name
      }.to raise_error(DSLCompose::SharedConfiguration::SharedConfigurationDoesNotExistError)
    end

    describe "where a block with this name already exists" do
      before(:each) do
        DSLCompose::SharedConfiguration.add :name, &dummy_proc
      end

      it "returns the expected proc" do
        expect(DSLCompose::SharedConfiguration.get(:name)).to be(dummy_proc)
      end
    end
  end

  describe :clear do
    describe "where a block already exists" do
      before(:each) do
        DSLCompose::SharedConfiguration.add :name, &dummy_proc
      end

      it "clears the list of procs" do
        DSLCompose::SharedConfiguration.clear
        # this proc should no longer exist
        expect {
          DSLCompose::SharedConfiguration.get :name
        }.to raise_error(DSLCompose::SharedConfiguration::SharedConfigurationDoesNotExistError)
      end
    end
  end
end
