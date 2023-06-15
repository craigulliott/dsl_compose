# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod do
  it "creates a new DSL with a method" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name
      end
    end

    expect(klass.get_dsl(:dsl_name).dsl_methods.count).to eq(1)
  end

  it "creates a new DSL with a unique method" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_unique_method :method_name
      end
    end

    expect(klass.get_dsl(:dsl_name).dsl_methods.count).to eq(1)
  end

  describe "required method" do
    it "creates a new DSL with a method" do
      klass = Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name, required: true
        end
      end

      expect(klass.get_dsl(:dsl_name).dsl_methods.count).to eq(1)
    end

    it "creates a new DSL with a unique method" do
      klass = Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_unique_method :method_name, required: true
        end
      end

      expect(klass.get_dsl(:dsl_name).dsl_methods.count).to eq(1)
    end
  end

  describe "the method name" do
    it "raises an error if using a string instead of a symbol for the DSL method name" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl :dsl_name do
            add_method "method_name"
          end
        end
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidNameError)
    end

    it "raises an error if adding multiple methods with the same name" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl :dsl_name do
            add_method :method_name
            add_method :method_name
          end
        end
      }.to raise_error(DSLCompose::DSL::MethodAlreadyExistsError)
    end
  end

  describe "the DSL description" do
    it "accepts and returns a description when requested" do
      klass = Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            description "This is a method description"
          end
        end
      end

      expect(klass.get_dsl(:dsl_name).dsl_methods.first.description).to eq("This is a method description")
    end

    it "raises an error if you try and set the dsl description multiple times" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl :dsl_name do
            add_method :method_name do
              description "This is a method description"
              description "This is another method description"
            end
          end
        end
      }.to raise_error(DSLCompose::DSL::DSLMethod::DescriptionAlreadyExistsError)
    end

    it "raises an error if you provide a symbol for the method description" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl :dsl_name do
            add_method :method_name do
              description :invalid_description
            end
          end
        end
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidDescriptionError)
    end

    it "raises an error if you provide an unexpected type for the method description" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl :dsl_name do
            add_method :method_name do
              description 123
            end
          end
        end
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidDescriptionError)
    end
  end
end
