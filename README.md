# DSLCompose

Ruby gem to add dynamic DSLs to classes

[![Gem Version](https://badge.fury.io/rb/dsl_compose.svg)](https://badge.fury.io/rb/dsl_compose)
[![Specs](https://github.com/craigulliott/dsl_compose/actions/workflows/specs.yml/badge.svg)](https://github.com/craigulliott/dsl_compose/actions/workflows/specs.yml)
[![Coding Style](https://github.com/craigulliott/dsl_compose/actions/workflows/linter.yml/badge.svg)](https://github.com/craigulliott/dsl_compose/actions/workflows/linter.yml)

## Key Features

* Contains a simple internal DSL which is used to declare dynamic DSLs on your classes
* Takes special care not to pollute the namespace of classes where it is used
* Use of your declared DSLs is validated at run time
* Automatically generate documentation and instructions for your DSLs
* Complete test covereage
* Very lightweight and no external dependencies

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add dsl_compose

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install dsl_compose

## Usage

DSLs are added to classes by including the DSLCompose module, and then calling the add_dsl singleton method within the class or a child class.

```ruby
class ApplicationRecord
  include DSLCompose::Composer

  define_dsl :my_dsl do
    add_method :foo do

    end
  end

end

```

Child classes can then use your new DSL

```ruby
class Foo << ApplicationRecord

  my_dsl do
    foo
  end

end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

We use [Conventional Commit Messages](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13).

Code should be linted and formatted according to [Ruby Standard](https://github.com/standardrb/standard).

Publishing is automated via github actions and Googles [Release Please](https://github.com/google-github-actions/release-please-action) github action

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/craigulliott/dsl_compose. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/craigulliott/dsl_compose/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DSLCompose project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/craigulliott/dsl_compose/blob/master/CODE_OF_CONDUCT.md).
