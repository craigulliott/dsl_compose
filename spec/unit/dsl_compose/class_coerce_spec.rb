# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::ClassCoerce do
  let(:class_coerce) { DSLCompose::ClassCoerce.new "Integer" }

  describe :initialize do
    it "initializes a new ClassCoerce without raising any errors" do
      expect {
        DSLCompose::ClassCoerce.new "Integer"
      }.to_not raise_error
    end

    it "raises an error if an invalid class name isp provided" do
      expect {
        DSLCompose::ClassCoerce.new :not_a_string
      }.to raise_error DSLCompose::ClassCoerce::UnexpectedClassNameError
    end
  end

  describe :to_class do
    it "returns the appropriate class when requested" do
      expect(class_coerce.to_class).to eq Integer
    end
  end
end
