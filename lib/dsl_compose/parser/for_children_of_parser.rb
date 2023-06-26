# frozen_string_literal: true

module DSLCompose
  class Parser
    class ForChildrenOfParser
      class AllBlockParametersMustBeKeywordParametersError < StandardError
        def message
          "All block parameters must be keyword parameters, i.e. `for_children_of FooClass do |base_class:|`"
        end
      end

      class ClassDoesNotUseDSLComposeError < StandardError
      end

      class NoBlockProvided < StandardError
      end

      class NoChildClassError < StandardError
        def message
          "No child_class was found, please call this method from within a `for_children_of` block"
        end
      end

      # This class will yield to the provided block for each class which extends the base_class, provided
      # that the child also uses at least one of the DSLs which have been defined on the base_class
      def initialize base_class, &block
        # assert the provided class has the DSLCompose::Composer module installed
        unless base_class.respond_to? :dsls
          raise ClassDoesNotUseDSLComposeError
        end

        @base_class = base_class

        # assert that a block was provided
        unless block
          raise NoBlockProvided
        end

        # if any arguments were provided, then assert that they are valid
        if block.parameters.any?
          # all parameters must be keyword arguments
          if block.parameters.filter { |p| p.first != :keyreq }.any?
            raise AllBlockParametersMustBeKeywordParametersError
          end
        end

        # yield the provided block for each child class of the provided base_class
        # which uses a defined DSL
        base_class.dsls.executions_by_class.each do |child_class, dsl|
          args = {}
          if BlockArguments.accepts_argument?(:child_class, &block)
            args[:child_class] = child_class
          end
          # set the child_class in an instance variable so that method calls to
          # `for_dsl` from within the block will have access to it
          @child_class = child_class
          # yield the block in the context of this class
          instance_exec(**args, &block)
        end
      end

      private

      # Given a dsl name, or array of dsl names, this method will yield to the
      # provided block once for each time a dsl with one of the provided names
      # was used on the correspondng child_class
      #
      # The value of child_class and base_class are set from the yield of this
      # classes initializer, meaning that the use of this method should look
      # something like this:
      #
      # for_children_of PlatformRecord do |base_class:|
      #   for_dsl [:number_field, :float_field] do |name:|
      #     ...
      #   end
      # end
      def for_dsl dsl_names, &block
        child_class = @child_class

        unless child_class
          raise NoChildClassError
        end

        ForDSLParser.new(@base_class, child_class, dsl_names, &block)
      end
    end
  end
end
