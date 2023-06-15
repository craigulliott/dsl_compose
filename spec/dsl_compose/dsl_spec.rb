# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DSLCompose::DSL do

  it "creates a new DSL within the class" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name
    end

    expect(klass.get_dsl(:dsl_name)).to be_a(DSLCompose::DSL)
  end

  describe "the DSL name" do

    it "returns the dsl name when requested" do
      klass = Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name
      end

      expect(klass.get_dsl(:dsl_name).get_name).to eq(:dsl_name)
    end

    it "raises an error if using a string instead of a symbol for the DSL name" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl "dsl_name"
        end
      }.to raise_error(DSLCompose::DSL::Errors::InvalidName)
    end

    it "raises an error if passing an unexpected type for the DSL name" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl 123
        end
      }.to raise_error(DSLCompose::DSL::Errors::InvalidName)
    end

    it "raises an error if creating multiple dsls with the same name within one class" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl :dsl_name
          define_dsl :dsl_name
        end
      }.to raise_error(DSLCompose::DSLs::Errors::DSLAlreadyExists)
    end

  end


  describe "the DSL description" do

    it "accepts and returns a dsl description when requested" do
      klass = Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          description "This is a description"
        end
      end

      expect(klass.get_dsl(:dsl_name).get_description).to eq("This is a description")
    end

    it "raises an error if you try and set the dsl description multiple times" do
      expect {
        klass = Class.new do
          include DSLCompose::Composer
          define_dsl :dsl_name do
            description "This is a description"
            description "This is another description"
          end
        end
      }.to raise_error(DSLCompose::DSL::Errors::DescriptionAlreadyExists)
    end

    it "raises an error if you provide a symbol for the DSL description" do
      expect {
        klass = Class.new do
          include DSLCompose::Composer
          define_dsl :dsl_name do
            description :invalid_description
          end
        end
      }.to raise_error(DSLCompose::DSL::Errors::InvalidDescription)
    end

    it "raises an error if you provide an unexpected type for the DSL description" do
      expect {
        klass = Class.new do
          include DSLCompose::Composer
          define_dsl :dsl_name do
            description 123
          end
        end
      }.to raise_error(DSLCompose::DSL::Errors::InvalidDescription)
    end

  end

end
