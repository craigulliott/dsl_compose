module DSLCompose
  # This class provides a skeleton for creating your own DSL readers.
  #
  # All classes which extend from this base class must follow a strict naming convention. The class name
  # must be the camelcased form of the DSL name, followed by the string "DSLReader". For example, a reader
  # for a DLS named `:foo_bar` must have the class name `FooBarDSLReader`, as seen below
  #
  # class FooBarDSLReader < DSLCompose::ReaderBase
  #  # ...
  # end
  class ReaderBase
    attr_reader :base_class
    attr_reader :dsl_name
    attr_reader :reader

    def initialize base_class
      @base_class = base_class
      # get the DSL name from the class name
      @dsl_name = dsl_name_from_class_name self.class
      # create the reader
      @reader = DSLCompose::Reader.new(base_class, @dsl_name)
    end

    private

    def dsl_name_from_class_name reader_class
      camelcased = reader_class.name.split("::").last.gsub(/DSLReader\Z/, "")
      underscored = camelcased.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2')
      underscored.downcase.to_sym
    end

    def dsl_used?
      @reader.dsl_used?
    end

    def dsl_used_on_ancestors?
      @reader.dsl_used_on_ancestors?
    end

    def dsl_used_on_class_or_ancestors?
      @reader.dsl_used_on_class_or_ancestors?
    end

    def last_execution
      @reader.last_execution
    end

    def last_execution!
      @reader.last_execution!
    end

    def executions
      @reader.executions
    end

    def ancestor_executions
      @reader.ancestor_executions
    end

    def all_executions
      @reader.all_executions
    end
  end
end
