module DSLCompose
  # A small helper to fix indentation and clean up whitespace in
  # strings which were created with rubys heredoc syntax.
  module FixHeredocIndentation
    # This method is used to fix the indentation of heredoc strings.
    # It will remove the leading whitespace from each line of the string
    # and remove the leading newline from the string.
    def self.fix_heredoc_indentation string
      # replace all tabs with spaces
      string = string.gsub(/\t/, "  ")
      # remove empty lines from the start of the string
      string = string.gsub(/\A( *\n)+/, "")
      # remove empty lines from the end of the string
      string = string.gsub(/( *\n)+\Z/, "")
      # removes the number of leading spaces on the first line, from
      # all the other lines
      string = string.gsub(/^#{string[/\A */]}/, "")
      # collapse lines which are next to each other onto the same line
      # because they are really the same paragraph
      string.gsub(/([^ \n])\n([^ \n])/, '\1 \2')
    end
  end
end
