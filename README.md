# DSLCompose

Ruby gem to add dynamic DSLs to classes

[![Gem Version](https://badge.fury.io/rb/dsl_compose.svg)](https://badge.fury.io/rb/dsl_compose)
[![Specs](https://github.com/craigulliott/dsl_compose/actions/workflows/specs.yml/badge.svg)](https://github.com/craigulliott/dsl_compose/actions/workflows/specs.yml)
[![Types](https://github.com/craigulliott/dsl_compose/actions/workflows/types.yml/badge.svg)](https://github.com/craigulliott/dsl_compose/actions/workflows/types.yml)
[![Coding Style](https://github.com/craigulliott/dsl_compose/actions/workflows/linter.yml/badge.svg)](https://github.com/craigulliott/dsl_compose/actions/workflows/linter.yml)

## Key Features

* Contains a simple internal DSL which is used to declare dynamic DSLs on your classes
* Takes special care not to pollute the namespace of classes where it is used
* Use of your declared DSLs is strictly validated at run time
* Automatically generate documentation for your DSLs
* Extensive test coverage
* Very lightweight and no external dependencies
* Share common DSL configuration between DSLs

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add dsl_compose

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install dsl_compose

## Usage

DSLs are defined and added to classes by including the `DSLCompose::Composer` module, and then calling the `define_dsl` singleton method on that class. Those DSLs can then be used on child classes (classes which extend the original class).

### Defining your DSL

```ruby
class Foo
  include DSLCompose::Composer

  # Define and name your DSL. Your DSL will be available on this
  # class and any children of this class.
  define_dsl :your_dsl do

    # A description of your DSL
    description <<~DESCRIPTION
      Add a description of your DSL here, this description will be
      used when generating the documentation for your DSL.

      You can use **Markdown** in this description.
    DESCRIPTION

    # You can add required or optional arguments to the initial method which is used
    # to call your dynamic DSL (for optional arguments, use `optional` instead of
    # `required`)
    #
    # Arguments are validated, and their expected type must be defined. Supported
    # argument types are :integer, :boolean, :float, :string, :symbol, :class or :object
    # when :class is used, it should be provided to your final DSL as a string of the
    # classes name, such as "Users::UserModel" and not the actual class.
    requires :first_dsl_argument, :symbol do
      # You should provide descriptions for your arguments. These descriptions will
      # be used when generating your documentation. This description supports markdown
      description "A description of the first argument for this method"
    end

    # Define a method which will be available within your DSL. These
    # methods will be exposed inside your DSL and can be called multiple times.
    add_method :an_optional_method do
      # You should provide descriptions for your methods. These descriptions will
      # be used when generating your documentation. Both of these descriptions
      # accept markdown
      description "A description of your method"

      # Add your method argument definition here
    end

    # Define a required method within your DSL. An error will be raised if a class
    # uses your DSL but does not execute this method
    add_method :a_required_method, required: true do
      # Add your description here
      # Add any method arguments here (more info below about method arguments)
    end

    # Define a method which can only be called once within your DSL. These
    # "unique" methods will raise an error of they are called multiple times.
    #
    # unique methods can be optionally marked as required.
    add_unique_method :an_optional_method do
      # Add your description and any method arguments here (more info below about method arguments)
    end

    # Define a method in your DSL which takes arguments
    add_method :your_method do
      description "A description of your DSL method"

      # You can add required arguments to your methods. The order in which you
      # define these arguments determines the order of the arguments in your final DSL.
      #
      # Arguments are validated, and their expected type must be defined. Supported
      # argument types are :integer, :boolean, :float, :string or :symbol
      requires :first_method_argument, :string do
        # You should provide descriptions for your arguments too. These descriptions will
        # be used when generating your documentation. This description supports markdown
        description "A description of the first argument for this method"
      end

      # You can also add optional arguments to your DSL methods. All optional
      # arguments must be added after required ones. An error will be raised if
      # you define a required argument after an optional one. Optional arguments can
      # have an default value, if a default is not provided then nil will be assumed.
      optional :optional_argument, :integer, default: 123 do
        description "A description of an optional argument"

        # You can add validation to your arguments. A full list is provided later in this document
        validate_greater_than 0
      end

      # Required arguments for both DSLs and DSL methods are assumed to be standard ruby
      # arguments by default, but can be declared as keyword arguments by passing `kwarg: true`.
      # This is useful because sometimes keyword arguments can make your DSL more readable. This
      # option does not exist for optional arguments, because optional arguments are always kwargs.
      requires :required_keyword_argument, :symbol, kwarg: true do
        # You should provide descriptions for your arguments. These descriptions will
        # be used when generating your documentation. This description supports markdown
        description "A description of the first argument for this method"
      end

      # All optional and required arguments can optionally accept an array of values. When using
      # your final DSL, a single item can be provided but will automatically be converted to an
      # array of items. All items in the array must be of the expected type.
      optional :another_optional_argument, :object, array: true do
        description "A description of an optional argument which accepts an array"

        # You can add validation to your arguments. A full list is provided later in this document
        validate_is_a Date
      end
    end

  end
end

```

The methods `title` and `namespace` are also available at the top level of your DSL definition. These methods can provide useful metadata when generating documentation, but are typically only useful in much larger systems involving many different DSLs.

```ruby
class Foo
  include DSLCompose::Composer

  # DSLs have some top level methods which allow you to set some useful
  # metadata for use when generating documentation.
  define_dsl :your_dsl do
    # You can give your DSLs a friendly title.
    title "My Friendly DSL Title"

    # You can also logically group a set of DSLs together by setting the same
    # namespace on each of them.
    namespace :my_namespace

    # You can also describe this DSL.
    # Unlike `title` and `namespace`, you can set descriptions on all of your
    # DSL methods and arguments too (as seen in the various examples above)
    description "A description of your DSL"

  end
end
```

### Shared Configuration

If you are composing many DSLs across one or many classes and these DSLs share common configuration, then you can share configuration between them.

Define your shared configuration

```ruby
DSLCompose::SharedConfiguration.add :my_common_validators do
  validate_not_end_with [:_id, :_at, :_count, :_type]
  validate_not_in [:type, :stage]
  validate_length minimum: 0, maximum: 10
  validate_format /\A[a-z]+(_[a-z]+)*\Z/
end
```

Use your shared DSL from within any of your DSL compositions

```ruby
class Foo
  include DSLCompose::Composer

  define_dsl :your_dsl do
    optional :optional_argument, :integer do
      # this will import and apply your shared configuration
      import_shared :my_common_validators
    end

  end
end
```

You can use `import_shared` anywhere within your DSL definition, you can even use `import_shared` within other shared configuration

### Using your DSL

Child classes can then use your new DSL

```ruby
class Bar < Foo

  your_dsl :first_dsl_argument, do
    your_method "first_method_argument", optional_argument: 123
  end

end
```

## Examples

### Defining a DSL which can be used to configure a client library

Define the DSL

```ruby
class MyClientLibrary
  include DSLCompose::Composer

  define_dsl :configure do
    description "Configure the settings for MyClientLibrary"

    add_unique_method :api_key, required: true do
      description <<~DESCRIPTION
        Your API key.

        API keys can be generated from your developer
        portal at https://developer.example.com/keys
      DESCRIPTION

      requires :key, :string do
        description "The api key"
        validate_format /\A[a-z]{4}-[a-z0-9]{16}\Z/
      end
    end

    add_method :log_provider, required: true do
      description "Activate and configure a log provider for MyClientLibrary"

      requires :provider, :symbol do
        description "The log provider"
        validate_in [:stdout, :rails]
      end

      optional :verbosity, :integer do
        description "The log provider"
        validate_greater_than_or_equal_to 0
        validate_less_than_or_equal_to 3
      end
    end

  end
end
```

Using the DSL

```ruby
MyClientLibrary.configure do
  api_key "afdl-f1ifb2tslhzqwdis"
  log_provider :stdout, verbosity: 1
  log_provider :rails, verbosity: 3
end
```

## Parsing complicated DSLs

A parser class can be used to process complicated DSLs. In the example below, a base class named SomeBaseClass has DSLs named :dsl1, and :dsl2.

```ruby
# create your own parser by creating a new class which extends DSLCompose::Parser
class MyParser < DSLCompose::Parser
  # `for_children_of` will process SomeBaseClass and yield the provided
  # block once for every class which extends SomeBaseClass.
  #
  # If you only want to process classes at the end of the class hierarchy (classes
  # which extend the provided base class, but do not have their own children) then
  # use `for_final_children_of` instead of `for_children_of`
  #
  # Both `for_children_of` and `for_final_children_of` accept an optional parameter
  # named skip_classes which accepts an array of class names which should be skipped.
  for_children_of SomeBaseClass do |child_class:|
    add_documentation <<~DESCRIPTION
      You can optionally provide a description of anything specific that your parser
      does in this block, this description will be used when generating documentation

      This description accepts markdown.

      Do not add a description here if the parser does not have any business logic here
      other than making calls to `for_dsl`, `for_dsl_or_inherited_dsl` or `for_inherited_dsl`
    DESCRIPTION

    # `for_dsl` accepts a DSL name or an array of DSL names and will yield it's
    # provided block once for each time a DSL of that name has been used
    # directly on the child_class.
    #
    # If you want to yield the provided block for classes which didn't directly use
    # one of the provided DSLs, but the DSL was used on one of their ancestors, then
    # use `for_inherited_dsl :dsl_name` instead of `for_dsl  :dsl_name`. If you want
    # the block to yield whether the DSL was used directly on the provided class or
    # anywhere in it's ancestor chain, then use `for_dsl_or_inherited_dsl :dsl_name`.
    #
    # An error will be raised if any of the provided DSL names does not exist.
    #
    # You can optionally provide keyword arguments which correspond to any
    # arguments that were defined for the DSL, if multiple dsl names are provided
    # then the requested dsl argument must be present on all DSLs otherwise an
    # error will be raised. The parser is aware of class inheritance, and will
    # consider a DSL to have been executed on the actual class it was used, and
    # any classes which are descendants of that class.
    #
    # You can also request an ExecutionReader object here by including the
    # argument `:reader`. The resulting reader object will allow to to access the methods
    # which were called within this use of your DSL. There is more documentation about
    # Reader classes below.
    for_dsl [:dsl1, :dsl2] do |dsl_name:, a_dsl_argument:, reader:|
      add_documentation <<~DESCRIPTION
        You can optionally provide a description of anything specific that your parser
        does in this block, this description will be used when generating documentation.

        This description accepts markdown.

        Do not add a description here if the parser does not have any business logic here
        other than making calls to `for_method`
      DESCRIPTION

      # Within a `for_dsl` block you can determine if a specific DSL method was used
      # with the `method_called?` method. This method will return true if the method was
      # used, otherwise it will return false. If a method with the provided name does not
      # exist for the DSL, then an error will be raised.
      was_some_method_name_used = method_called? :some_method_name

      # `for_method` accepts a method name or an array of method names and will
      # yield it's provided block once for each time a method with this name is
      # executed within the DSL.
      #
      # An error will be raised if any of the provided method names does not exist
      #
      # You can optionally provide keyword arguments which correspond to any
      # arguments that were defined for the DSL method, if multiple method names
      # are provided then the requested dsl argument must be present on all DSLs
      # otherwise an error will be raised.
      for_method :some_method_name do |method_name:, a_method_argument:|
        add_documentation <<~DESCRIPTION
          You can optionally provide a description of anything specific that your parser
          does in this block, this description will be used when generating documentation.

          This description accepts markdown.
        DESCRIPTION

        # your business logic goes here
        ...
      end
    end
  end
end
```

In addition to parser classes (or as a useful tool within parser classes) you can access the results of DSL execution with a Reader class.

```ruby
# Create a new Reader object.
#
# Reader objects build and return ExecutionReader classes which expose a
# simple API to access the arguments, methods and method arguments which
# were provided when using a DSL.
#
# In the example below, MyClass is a class, or descendant of a class which
# had a DSL defined on it with the name :my_dsl.
#
# An error will be raised if a DSL with the provided name was never defined
# on MyClass or any of its ancestors.
reader = DSLCompose::Reader.new MyClass, :my_dsl

# `reader.last_execution` will return an ExecutionReader which represents
# the last time the DSL was used.
#
# If the dsl has been executed once or more on the provided class, then
# the last (most recent) execution will be returned. If the DSL was not
# executed on the provided class, then we traverse up the classes ancestors
# and look for the last (most recent) time it was executed on each ancestor.
#
# If no execution of the DSL is found, then nil will be returned
execution = reader.last_execution

# `execution.method_called?` will return true if the method with the provided
# name was called, if a method with this name does exist, but was not called
# then false will be returned. If a method with this name does not exist, then
# an error will be raised.
execution.method_called? :my_dsl_method # returns true/false

# You can directly access the argument values for methods by calling the
# ExecutionReader object with the same method name as the defined method on
# your DSL.
#
# If your method was defined as unique via `add_unique_method` then this will
# return a single ArgumentsReader which represents the arguments provided to
# your method.
#
# Note that `execution.my_dsl_method` will return nil if the method was
# not used in this DSL execution, so you should either check this first
# with `method_called?` or use ruby's safe navigation operator (`.&`). If
# you want to enforce use of this method, then it should be marked as
# required when your DSL was originally defined.
execution.my_dsl_method.my_dsl_method_argument

# If your method was not defined as unique, then this will return an array
# representing each time the method was used. If the method was never used
# then an empty array will be returned
execution.my_dsl_method.each do |arguments|
  arguments.my_dsl_method_argument # returns the value provided for the argument, or nil
end

# Returns an array of ExecutionReaders to represent each time the DSL was used
# on the provided class.
executions = reader.executions

# Returns an array of ExecutionReaders to represent each time the DSL was used
# on the ancestors of the provided class, but not on the provided class itself.
# The executions will be returned in the order they were executed, which is the
# earliest ancestor first and if the DSL was used more than once on a class then
# the order they were used.
executions = reader.ancestor_executions

# Returns an array of ExecutionReaders to represent each time the DSL was used
# on the provided class or ancestors of the provided class. The executions will
# be returned in the order they were executed, which is the earliest ancestor first
# and if the DSL was used more than once on a class then the order they were used.
executions = reader.all_executions

# Returns true if dsl has been executed once or more on the provided class,
# otherwise returns false.
was_used = reader.dsl_used?

# Returns true if dsl has been executed once or more on one of the ancestors
# of the provided class, otherwise returns false.
was_used = reader.dsl_used_on_ancestors?

# Returns true if dsl has been executed once or more on the provided class or
# any of its ancestors, otherwise returns false.
was_used = reader.dsl_used_on_class_or_ancestors?

# `execution.arguments` returns an ArgumentsReader object which allows access
# via dot notation to to any argument values provided to the DSL
execution.arguments.my_dsl_argument # returns the value provided for the argument, or nil
```

A ReaderBase class is also provided. You can extend this class to create your own Reader objects and provide a much cleaner interface to your specific DSLs.

```ruby
# This is an example DSL for configuring which database and schema should be used
# by classes which extend a BaseModel (it's from a hypothetical ORM).
class BaseModel
  # define a DSL which can be used on descendants of this class
  # to determine which database should be used
  define_dsl :database_configuration do
    requires :server_type, :symbol do
      validate_in [:postgres, :mysql]
    end
    requires :server_name, :symbol
    optional :database_name, :symbol
  end
  # define a DSL to set the schema which should be used
  define_dsl :schema do
    requires :schema_name, :symbol
  end
end

# A hypothetical model which extends BaseModel and uses this DSL
class User < BaseModel
  # Use the primary postgres server and the default database_name (because
  # we are not using the optional `database_name: :foo` argument).
  database_configuration :postgres, :primary
  # Persist this models data in the `users` schema.
  schema :users
end

# An example reader which could be created to provide a more concise
# interface to this DSL.
# Because this DSL Reader is named DatabaseConfigurationDSLReader it
# will automatically refer to the dsl named :database_configuration.
class DatabaseConfigurationDSLReader < DSLCompose::ReaderBase
  # The three methods below provide a more concise access to the DSLs
  # arguments. If the DSL was never used on the provided class, or any
  # of it's ancestors, then an error will be raised. This error will
  # be raised because we are using `last_execution!` instead of `last_execution`.
  def server_type
    last_execution!.arguments.server_type
  end

  def server_name
    last_execution!.arguments.server_name
  end

  def database_name
    last_execution!.arguments.database_name
  end

  # Returns true or false, depending on if the optional database_name
  # attribute was used when executing the DSL. If the DSL was never
  # used on the provided class, or any of it's ancestors, then an error will
  # be raised (because of the bang method).
  def has_database_name?
    last_execution!.arguments.database_name != nil
  end

  # This method is provided as an example of how to reference other DSLs within
  # your reader.
  def schema_name
    last_execution_of_schema&.arguments&.schema_name || :public
  end

  private

  # This method is used by the schema_name method above, and is included as an
  # example of how to reference other DSLs within your Reader.
  def last_execution_of_schema
    # Note that there is no bang method here (no "!" after last_execution), so it
    # will return nil if the DSL was not used.
    @schema_reader ||= DSLCompose::Reader.new(@base_class, :schema).last_execution
  end
end

# Use our DatabaseConfigurationDSLReader when parsing this class to
# enjoy a more concise API for accessing our DSL values
reader = DatabaseConfigurationDSLReader.new(User)
reader.server_type # :postgres
reader.has_database_name? # false
reader.schema_name # :users

```


## Argument validations

The following validations can be added to the arguments of your DSL methods. Validations can be added to both required and optional arguments, and you can add multiple validations to each argument.

### Numeric Attributes (:integer and :float)

```ruby
  define_dsl :my_dsl do
    add_method :my_method do

      requires :my_first_argument, :integer do
        # The argument must be greater than a provided number.
        validate_greater_than 0

        # The argument must be greater than or equal to a provided number.
        validate_greater_than_or_equal_to 0

        # The argument must be less than a provided number.
        validate_less_than 10

        # The argument must be less than or equal to a provided number.
        validate_less_than_or_equal_to 10

        # The argument must be exactly equal to a provided number.
        validate_equal_to 5

        # The argument must not be one of the provided values.
        validate_not_in [1, 2]

        # The argument must be one of the provided values.
        validate_in [3, 4]
      end

    end
  end
```

### String attributes (:string)

```ruby
  define_dsl :my_dsl do
    add_method :my_method do

      requires :my_first_argument, :string do

        # The text value must be at least a provided length.
        validate_length minimum: 0

        # The text value must be at most a provided length.
        validate_length maximum: 10

        # you can combine the minimum and maximum validations
        validate_length minimum: 0, maximum: 10

        # The length of the text must be exactly the provided value.
        validate_length is: 10

        # The argument must not be one of the provided values.
        validate_not_in ["foo", "bar"]

        # The argument must be one of the provided values.
        validate_in ["cat", "dog"]

        # The argument must start with the following string.
        validate_start_with ["foo_"]

        # The argument must not start with the following string.
        validate_not_start_with ["foo_"]

        # The argument must end with the following string.
        validate_end_with ["_foo"]

        # The argument must not end with the following string.
        validate_not_end_with ["_foo"]

        # The argument must match the provided regex.
        validate_format /\A[A-Z][a-z]+\Z/

      end

    end
  end
```

### Symbol attributes (:symbol)

```ruby
  define_dsl :my_dsl do
    add_method :my_method do

      requires :my_first_argument, :symbol do

        # The text value must be at least a provided length.
        validate_length minimum: 0

        # The text value must be at most a provided length.
        validate_length maximum: 10

        # you can combine the minimum and maximum validations
        validate_length minimum: 0, maximum: 10

        # The length of the text must be exactly the provided value.
        validate_length is: 10

        # The argument must not be one of the provided values.
        validate_not_in [:foo, :bar]

        # The argument must be one of the provided values.
        validate_in [:cat, :dog]

        # The argument must start with the following string.
        validate_start_with [:foo_]

        # The argument must not start with the following string.
        validate_not_start_with [:foo_]

        # The argument must end with the following string.
        validate_end_with [:_foo]

        # The argument must not end with the following string.
        validate_not_end_with [:_foo]

        # The argument must match the provided regex.
        validate_format /\A[A-Z][a-z]+\Z/

      end

    end
  end
```

### Boolean attributes (:boolean)

```ruby
  define_dsl :my_dsl do
    add_method :my_method do

      requires :my_first_argument, :boolean do

        # The argument must be equal to a provided value
        # for boolean attributes, this provided value can be either false or true.

        # The provided attribute must be `false`.
        validate_equal_to false

      end

    end
  end
```

### Class attributes (:class)

```ruby
  define_dsl :my_dsl do
    add_method :my_method do

      requires :my_first_argument, :class do

        # The class name must start with the following string.
        validate_start_with ["foo_"]

        # The class name must not start with the following string.
        validate_not_start_with ["foo_"]

        # The class name must end with the following string.
        validate_end_with ["_foo"]

        # The class name must not end with the following string.
        validate_not_end_with ["_foo"]

        # The class name must match the provided regex.
        validate_format /\A[A-Z][a-z]+\Z/

      end

    end
  end
```

### Object attributes (:object)

```ruby
  define_dsl :my_dsl do
    add_method :my_method do

      requires :my_first_argument, :object do

        # The provided attribute must be an instantiated object which
        # is an instance of the class.
        #
        # For example, this would accept a regexp object such as /[a-z]+/
        validate_is_a Regexp

      end

    end
  end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

We use [Conventional Commit Messages](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13).

Code should be linted and formatted according to [Ruby Standard](https://github.com/standardrb/standard).

Publishing is automated via github actions and Googles [Release Please](https://github.com/google-github-actions/release-please-action) github action

We prefer using squash-merges when merging pull requests because it helps keep a linear git history and allows more fine grained control of commit messages which get sent to release-please and ultimately show up in the changelog.

Type checking is enabled for this project. You can find the corresponding `rbs` files in the sig folder.

Install types for the packages used in development (such as `rspec`) by running

    $ rbs collection install

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/craigulliott/dsl_compose. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/craigulliott/dsl_compose/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DSLCompose project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/craigulliott/dsl_compose/blob/master/CODE_OF_CONDUCT.md).
