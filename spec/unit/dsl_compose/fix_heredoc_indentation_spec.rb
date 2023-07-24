# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::FixHeredocIndentation do
  describe :fix_heredoc_indentation do
    it "removes newlines and empty lines from the start and end of the string and collapses lines next to each other into paragraphs" do
      test_string = <<-TEST_STRING


      Foo
      Bar

      Should work fine with special chars $
      * and so on

      It should not remove too much indentation from lines which have additional indentation
        Such as this

      TEST_STRING

      expected_string = "Foo\nBar\n\nShould work fine with special chars $\n* and so on\n\nIt should not remove too much indentation from lines which have additional indentation\n  Such as this"

      expect(DSLCompose::FixHeredocIndentation.fix_heredoc_indentation(test_string)).to eq(expected_string)
    end
  end
end
