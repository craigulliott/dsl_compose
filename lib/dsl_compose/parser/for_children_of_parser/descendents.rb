# frozen_string_literal: true

module DSLCompose
  class Parser
    class ForChildrenOfParser
      class Descendents
        def initialize base_class, final_children_only
          @base_class = base_class
          @final_children_only = final_children_only
        end

        def classes
          # all objects which extend the provided base class
          extending_classes = ObjectSpace.each_object(Class).select { |klass| klass < @base_class }

          # sort the results, classes are ordered first by the depth of their namespace, and second
          # by their name
          extending_classes.sort_by! do |child_class|
            "#{child_class.name.split("::").count}_#{child_class.name}"
          end

          # if this is not a final child, but we are processing final children only, then skip it
          if @final_children_only
            # reject any classes which have descendents
            extending_classes.reject! do |child_class|
              has_descendents child_class
            end
          end

          extending_classes
        end

        private

        def has_descendents base_class
          ObjectSpace.each_object(Class).count { |klass| klass < base_class } > 0
        end
      end
    end
  end
end
