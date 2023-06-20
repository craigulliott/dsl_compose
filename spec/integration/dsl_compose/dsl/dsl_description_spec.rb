# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL do
  let(:dummy_class) { Class.new { include DSLCompose::Composer } }

  it "adds and returns a dsl description when requested" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        description "This is a description"
      end
    end

    expect(DSLCompose::DSLs.class_dsl(klass, :dsl_name).description).to eq("This is a description")
  end

  describe "extending an empty DSL" do
    before(:each) do
      dummy_class.define_dsl :dsl_name do
      end
    end

    it "allows adding a description" do
      dummy_class.define_dsl :dsl_name do
        description "This is a description set in the second call to define_dsl"
      end
      expect(DSLCompose::DSLs.class_dsl(dummy_class, :dsl_name).description).to eq("This is a description set in the second call to define_dsl")
    end
  end

  describe "extending a DSL which already contains a description" do
    before(:each) do
      dummy_class.define_dsl :dsl_name do
        description "This is a description set in the first call to define_dsl"
      end
    end

    it "extends a DSL by adding a description" do
      expect {
        dummy_class.define_dsl :dsl_name do
          description "This is a description set in the second call to define_dsl"
        end
      }.to raise_error(DSLCompose::DSL::DescriptionAlreadyExistsError)
    end
  end

  it "raises an error if you try and set the dsl description multiple times" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          description "This is a description"
          description "This is another description"
        end
      end
    }.to raise_error(DSLCompose::DSL::DescriptionAlreadyExistsError)
  end

  it "raises an error if you provide a symbol for the DSL description" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          description :invalid_description
        end
      end
    }.to raise_error(DSLCompose::DSL::InvalidDescriptionError)
  end

  it "raises an error if you provide an unexpected type for the DSL description" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          description 123
        end
      end
    }.to raise_error(DSLCompose::DSL::InvalidDescriptionError)
  end
end
