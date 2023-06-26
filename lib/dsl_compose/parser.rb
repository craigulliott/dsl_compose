# frozen_string_literal: true

module DSLCompose
  # A base class for building parsers which can be used to act upon
  # our dynamically defined DSLs
  #
  # Example syntax...
  #
  # for_children_of SomeBaseClass do |child_class:|
  #   for_dsl [:dsl_name1, :dsl_name2] do |dsl_name:, a_dsl_argument:|
  #     for_method :some_method_name do |method_name:, a_method_argument:|
  #       ...
  #     end
  #   end
  # end
  class Parser
    class NotInitializable < StandardError
    end

    # this class is not designed to be initialized, the parser is made up of
    # singlerton methods and is designed to be executed as soon as it is required
    # into an application
    def initialize
      raise NotInitializable
    end

    # the first step in defining a parser is to set the base_class, this method
    # will yield to the provided block for each child class of the provided base_class
    # provided that the child_class uses at least one of the base_classes defined DSLs
    def self.for_children_of base_class, &block
      # we parse the provided block in the context of the ForChildrenOfParser class
      # to help make this code more readable, and to limit polluting the current namespace
      ForChildrenOfParser.new(base_class, &block)
    end
  end
end
