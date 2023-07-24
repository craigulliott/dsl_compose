module DSLCompose
  # A small helper to fix indentation and clean up whitespace in
  # strings which were created with rubys heredoc syntax.
  module FixHeredocIndentation
    # This method is used to trim empty lines from the start and end of
    # a block of markdown, it will also fix the indentation of heredoc
    # strings by removing the leading whitespace from the first line, and
    # that same amount of white space from every other line
    def self.fix_heredoc_indentation string
      # replace all tabs with spaces
      string = string.gsub(/\t/, "  ")
      # remove empty lines from the start of the string
      string = string.gsub(/\A( *\n)+/, "")
      # remove empty lines from the end of the string
      string = string.gsub(/( *\n)+\Z/, "")
      # removes the number of leading spaces on the first line, from
      # all the other lines
      string.gsub(/^#{string[/\A */]}/, "")
    end
  end
end
