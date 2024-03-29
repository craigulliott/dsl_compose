# frozen_string_literal: true

module DSLCompose
  class Parser
    class ForChildrenOfParser
      class Descendants
        def initialize base_class, final_children_only, skip_classes = []
          @base_class = base_class
          @final_children_only = final_children_only
          @skip_classes = skip_classes
        end

        def classes
          # all objects which extend the provided base class
          extending_classes = subclasses @base_class

          # sort the results
          #
          # classes are ordered first by name
          extending_classes.sort_by! do |child_class|
            "#{child_class.name.split("::").count}_#{has_descendants(child_class) ? 0 : 1}_#{child_class.name}"
          end
          # then by ansestory chain (i.e. ancestors before descendants)
          extending_classes.sort! do |a, b|
            if a < b
              1
            elsif a > b
              -1
            else
              a.name <=> b.name
            end
          end

          # reject any classes which we are skipping
          extending_classes.reject! do |child_class|
            @skip_classes.include? child_class.name
          end

          # if this is not a final child, but we are processing final children only, then skip it
          if @final_children_only
            # reject any classes which have descendants
            extending_classes.reject! do |child_class|
              has_descendants child_class
            end
          end

          extending_classes
        end

        private

        # recursively get all sub classes of the provided base class
        def subclasses base_class
          base_class.subclasses.filter { |subclass| class_is_still_defined? subclass }.map { |subclass|
            [subclass] + subclasses(subclass)
          }.flatten
        end

        def has_descendants base_class
          base_class.subclasses.count { |subclass| class_is_still_defined? subclass } > 0
        end

        def class_is_still_defined? klass
          Object.const_defined?(klass.name) && Object.const_get(klass.name).equal?(klass)
        end
      end
    end
  end
end
