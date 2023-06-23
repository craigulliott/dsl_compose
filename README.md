# DSLCompose

Ruby gem to add dynamic DSLs to classes

[![Gem Version](https://badge.fury.io/rb/dsl_compose.svg)](https://badge.fury.io/rb/dsl_compose)
[![Specs](https://github.com/craigulliott/dsl_compose/actions/workflows/specs.yml/badge.svg)](https://github.com/craigulliott/dsl_compose/actions/workflows/specs.yml)
[![Types](https://github.com/craigulliott/dsl_compose/actions/workflows/types.yml/badge.svg)](https://github.com/craigulliott/dsl_compose/actions/workflows/types.yml)
[![Coding Style](https://github.com/craigulliott/dsl_compose/actions/workflows/linter.yml/badge.svg)](https://github.com/craigulliott/dsl_compose/actions/workflows/linter.yml)

## Key Features

* Contains a simple internal DSL which is used to declare dynamic DSLs on your classes
* Takes special care not to pollute the namespace of classes where it is used
* Use of your declared DSLs is validated at run time
* Automatically generate documentation and instructions for your DSLs
* Complete test coverage
* Very lightweight and no external dependencies

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add dsl_compose

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install dsl_compose

## Usage

DSLs are added to classes by including the DSLCompose::Composer module, and then calling the define_dsl singleton method within the class or a child class.

### Defining your DSL

```ruby
class Foo
  include DSLCompose::Composer

  # Define and name the DSL. Your DSL will available on this
  # class and any children of this class.
  define_dsl :my_dsl do

    # A description of your DSL.
    description <<-DESCRIPTION
      Add a description of your DSL here, this description will be
      used when generating the documentation for your DSL.

      You can use **Markdown** in this description.
    DESCRIPTION

    # You can add required or optional arguments to the initial method which is used
    # to enter your dynamic DSL (for optional arguments, use `optional` instead of
    # `required`).
    #
    # Arguments are validated, and their expected type must be defined. Supported
    # argument types are :integer, :boolean, :float, :string or :symbol
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
      description "A description of my awesome method"

      # add your method argument definition here
    end

    # Define a required within your DSL. If a class uses your DSL but
    # does not execute this method then an error will be raised.
    add_method :a_required_method, required: true do
      # add your description and method argument definition here (see below)
    end

    # Define a method which can only be called once within your DSL. These
    # methods will raise an error of they are called multiple times.
    #
    # There "unique" methods can be optionally marked as required.
    add_unique_method :an_optional_method do
      # add your description and method argument definition here (see below)
    end

    # Define a method in your DSL which takes arguments
    add_method :my_method do
      # A description of my DSL method
      description "A description of my DSL method"

      # You can add required arguments to your methods. The order in which you
      # define these arguments determines the order of the arguments in your final DSL.
      #
      # Arguments are validated, and their expected type must be defined. Supported
      # argument types are :integer, :boolean, :float, :string or :symbol
      requires :first_method_argument, :string do
        # You should provide descriptions for your arguments. These descriptions will
        # be used when generating your documentation. This description supports markdown
        description "A description of the first argument for this method"
      end

      # You can also add optional arguments to your DSL methods. All optional
      # arguments must be added after required ones. An error will be raised if
      # you define a required argument after an optional one.
      optional :optional_argument, :integer do
        description "A description of an optional argument"

        # You can add validation to your arguments. A full list is provided later in this document
        validate_greater_than 0
      end
    end

  end
end

```

### Using your DSL

Child classes can then use your new DSL

```ruby
class Bar << Foo

  my_dsl :first_dsl_argument, do
    my_method "first_method_argument", optional_argument: 123
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
      description <<-DESCRIPTION
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
