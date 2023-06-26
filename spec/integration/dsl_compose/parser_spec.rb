# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser do
  it "can be extended without error to create a new parser" do
    expect {
      Class.new(DSLCompose::Parser)
    }.to_not raise_error
  end
end
