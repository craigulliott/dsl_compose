# DslCompose

Ruby gem to add dynamic DSLs to classes

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add dsl_compose

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install dsl_compose

## Usage

DSLs are added to classes by including the DSLCompose module, and then calling the add_dsl singleton method within the class or a child class.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

We use [Conventional Commit Messages](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13).

Publishing is automated via github actions and [googles release please](https://github.com/google-github-actions/release-please-action)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/craigulliott/dsl_compose. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/craigulliott/dsl_compose/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DslCompose project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/craigulliott/dsl_compose/blob/master/CODE_OF_CONDUCT.md).
