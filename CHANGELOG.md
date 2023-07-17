# Changelog

## [1.13.0](https://github.com/craigulliott/dsl_compose/compare/v1.12.0...v1.13.0) (2023-07-17)


### Features

* added for_final_children_of, for_inherited_dsl and for_dsl_or_inherited_dsl methods to the parser ([#35](https://github.com/craigulliott/dsl_compose/issues/35)) ([b01a629](https://github.com/craigulliott/dsl_compose/commit/b01a629e1b18540cbbd90ba53090b41b8fb41dfd))

## [1.12.0](https://github.com/craigulliott/dsl_compose/compare/v1.11.0...v1.12.0) (2023-07-13)


### Features

* parsers are now aware of class inheritance, and all classes now assume the DSL configurations of all their ancestors ([#33](https://github.com/craigulliott/dsl_compose/issues/33)) ([6a6cfb1](https://github.com/craigulliott/dsl_compose/commit/6a6cfb1fd9bb44c2ea949888c7b7be14ddc0cef8))

## [1.11.0](https://github.com/craigulliott/dsl_compose/compare/v1.10.0...v1.11.0) (2023-07-12)


### Features

* arguments can optionally accept arrays of values, also added a :class and :object type, and an associated "is_a" validator for :object ([#31](https://github.com/craigulliott/dsl_compose/issues/31)) ([acd7034](https://github.com/craigulliott/dsl_compose/commit/acd70345a4d1873e657d0e897f527269ca320453))

## [1.10.0](https://github.com/craigulliott/dsl_compose/compare/v1.9.1...v1.10.0) (2023-07-11)


### Features

* ability to easily share configuration between multiple DSLs ([#27](https://github.com/craigulliott/dsl_compose/issues/27)) ([38ff61b](https://github.com/craigulliott/dsl_compose/commit/38ff61bed7c9d4357a0019c40fc20bc54d62bebb))

## [1.9.1](https://github.com/craigulliott/dsl_compose/compare/v1.9.0...v1.9.1) (2023-07-11)


### Bug Fixes

* bug fix where argument class was using wrong type check for start and end with validators ([#25](https://github.com/craigulliott/dsl_compose/issues/25)) ([d16fd35](https://github.com/craigulliott/dsl_compose/commit/d16fd35d0b574eafe6ad9d68d4e7f5884e89c521))

## [1.9.0](https://github.com/craigulliott/dsl_compose/compare/v1.8.0...v1.9.0) (2023-07-11)


### Features

* start_with, not_start_with, end_with and not_end_with validators now accept an array of values to test against ([#23](https://github.com/craigulliott/dsl_compose/issues/23)) ([cddcb4b](https://github.com/craigulliott/dsl_compose/commit/cddcb4b629499e3af0d71cc27f5c2f1dd8ae76d5))

## [1.8.0](https://github.com/craigulliott/dsl_compose/compare/v1.7.0...v1.8.0) (2023-07-11)


### Features

* adding start_with, not_start_with, end_with and not_end_with ar… ([#21](https://github.com/craigulliott/dsl_compose/issues/21)) ([ea2f213](https://github.com/craigulliott/dsl_compose/commit/ea2f2130c1b9a856e89cbf9b4f09c0c3c739d3de))

## [1.7.0](https://github.com/craigulliott/dsl_compose/compare/v1.6.0...v1.7.0) (2023-07-07)


### Features

* better error messages ([#19](https://github.com/craigulliott/dsl_compose/issues/19)) ([a9afa6c](https://github.com/craigulliott/dsl_compose/commit/a9afa6cb1b7482d0d7a646b6872ca5e969393eb7))

## [1.6.0](https://github.com/craigulliott/dsl_compose/compare/v1.5.0...v1.6.0) (2023-07-07)


### Features

* added an interpreter clear method to erase state between tests ([#17](https://github.com/craigulliott/dsl_compose/issues/17)) ([9d0a0c9](https://github.com/craigulliott/dsl_compose/commit/9d0a0c9c521bed61f08fecaa388d1410f513498b))

## [1.5.0](https://github.com/craigulliott/dsl_compose/compare/v1.4.0...v1.5.0) (2023-07-07)


### Features

* adding a parser method to rerun the parser, this is most useful from within a test suite when you are testing the parser itself ([#15](https://github.com/craigulliott/dsl_compose/issues/15)) ([fe4de0e](https://github.com/craigulliott/dsl_compose/commit/fe4de0e53f78aff34de4ba1c432b10022d2b6ab4))

## [1.4.0](https://github.com/craigulliott/dsl_compose/compare/v1.3.0...v1.4.0) (2023-06-26)


### Features

* added a Parser class which can be used to react to any DSLs which have been defined and used ([8d2f16b](https://github.com/craigulliott/dsl_compose/commit/8d2f16b67ae98486a47e6e8d6d6af81be508cb06))

## [1.3.0](https://github.com/craigulliott/dsl_compose/compare/v1.2.0...v1.3.0) (2023-06-22)


### Features

* adding an executions_by_class method to make processing the configuration more convenient ([#8](https://github.com/craigulliott/dsl_compose/issues/8)) ([313507c](https://github.com/craigulliott/dsl_compose/commit/313507ca572f59c03162a91d58e62500a9464f25))
* fixing release please job ([#10](https://github.com/craigulliott/dsl_compose/issues/10)) ([880fa5b](https://github.com/craigulliott/dsl_compose/commit/880fa5b2aceed67aa9ff1e7cf53629af23e31b10))

## [1.2.0](https://github.com/craigulliott/dsl_compose/compare/v1.1.0...v1.2.0) (2023-06-22)


### Features

* adding arguments to initial DSL activation method ([bda7cd4](https://github.com/craigulliott/dsl_compose/commit/bda7cd4ef55bcd4bfd2be530b6a28645dee87885))

## [1.1.0](https://github.com/craigulliott/dsl_compose/compare/v1.0.0...v1.1.0) (2023-06-20)


### Features

* a first complete working version ([#3](https://github.com/craigulliott/dsl_compose/issues/3)) ([d64a666](https://github.com/craigulliott/dsl_compose/commit/d64a6663e5cedcf67af1c8cbad1736c2a7e81282))
* basic first version which includes internal DSL for composing dynamic DSLs ([37a3753](https://github.com/craigulliott/dsl_compose/commit/37a3753c68455bec579d879f4989f272480e2b06))


### Bug Fixes

* incorrect constant name used in version.rb ([a8cdd0b](https://github.com/craigulliott/dsl_compose/commit/a8cdd0b45fddf12fc1db8c0048c00e36cf183673))

## 1.0.0 (2023-06-09)


### Features

* publishing new gem (testing CI and CD) ([2fed15c](https://github.com/craigulliott/dsl_compose/commit/2fed15c4615c4b7943a7f40a6d8629ecf275b8ed))
