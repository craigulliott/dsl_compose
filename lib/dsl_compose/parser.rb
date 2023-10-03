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

    # The first step in defining a parser is to set the base_class, this method
    # will yield to the provided block for each child class of the provided base_class
    # provided that the child_class uses at least one of the base_classes defined DSLs.
    # If `final_children_only` is true, then this will cause the parser to only return
    # classes which are at the end of their class hierachy (meaning they dont have any
    # children of their own)
    def self.for_children_of base_class, final_children_only: false, skip_classes: [], rerun: false, &block
      unless rerun
        @runs ||= []
        @runs << {
          base_class: base_class,
          final_children_only: final_children_only,
          skip_classes: skip_classes,
          block: block
        }
      end

      # we parse the provided block in the context of the ForChildrenOfParser class
      # to help make this code more readable, and to limit polluting the current namespace
      ForChildrenOfParser.new(base_class, final_children_only, skip_classes, &block)
    end

    # this is a wrapper for the `for_children_of` method, but it provides a value
    # of true for the `final_children_only` argument. This will cause the parser to only
    # return classes which are at the end of the class hierachy (meaning they dont have
    # any children of their own)
    def self.for_final_children_of base_class, skip_classes: [], &block
      for_children_of base_class, final_children_only: true, skip_classes: skip_classes, &block
    end

    # this method is used to rerun the parser, this is most useful from within a test suite
    # when you are testing the parser or the effects of running the parser
    def self.rerun
      # rerun each parser for this specific class
      @runs&.each do |run|
        base_class = run[:base_class]
        block = run[:block]
        final_children_only = run[:final_children_only]
        skip_classes = run[:skip_classes]
        for_children_of base_class, rerun: true, final_children_only: final_children_only, skip_classes: skip_classes, &block
      end
    end

    # so we know which parsers have run, and in which order
    def self.inherited subclass
      @@all_parser_classes ||= []
      @@all_parser_classes << subclass
    end

    # this method is used to rerun all of the parsers, this is most useful from within a test suite
    # when you are testing the parser or the effects of running the parser
    def self.rerun_all
      @@all_parser_classes.each do |parser_class|
        parser_class.rerun
      end
    end
  end
end
