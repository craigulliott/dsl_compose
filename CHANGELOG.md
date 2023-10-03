# Changelog

## [2.15.3](https://github.com/craigulliott/dsl_compose/compare/v2.15.2...v2.15.3) (2023-10-03)


### Bug Fixes

* updating class sorting method so that it is stable (we were getting different results on ubuntu/the CI server) ([70139a1](https://github.com/craigulliott/dsl_compose/commit/70139a11fa5190c3019e95199656385676a10177))

## [2.15.2](https://github.com/craigulliott/dsl_compose/compare/v2.15.1...v2.15.2) (2023-10-03)


### Bug Fixes

* fix: sorting classes by ancestry chain (i.e. ancestors before descendants) in the parser ([c301c4b](https://github.com/craigulliott/dsl_compose/commit/c301c4b9e1393c996d5b29dd7a6fd0e2758ae109))

## [2.15.1](https://github.com/craigulliott/dsl_compose/compare/v2.15.0...v2.15.1) (2023-10-03)


### Bug Fixes

* sorting classes by ancestry chain (i.e. ancestors before descendants) in the parser ([4e7dd6f](https://github.com/craigulliott/dsl_compose/commit/4e7dd6fd302c50ee3147f76f59a52089fb6f39ee))

## [2.15.0](https://github.com/craigulliott/dsl_compose/compare/v2.14.3...v2.15.0) (2023-10-03)


### Features

* added option to skip certain provided classes within dsl parsers ([c2be111](https://github.com/craigulliott/dsl_compose/commit/c2be111289f4ca0b84b95e641c18bdbd784b5b6f))
* adding default values for dsl arguments ([b89bd69](https://github.com/craigulliott/dsl_compose/commit/b89bd697eb6598f5f723a28533bd3e67e4ab9207))


### Bug Fixes

* passing classes to skip to the parser as class names (strings) instead of the actual classes. This prevents this library holding a reference to those classes and preventing garbage collection of the classes when they are dynamically created/destroyed within a test suite. ([74b332a](https://github.com/craigulliott/dsl_compose/commit/74b332ab99b7cf96bb8468a06634ee217cd5c58b))

## [2.14.3](https://github.com/craigulliott/dsl_compose/compare/v2.14.2...v2.14.3) (2023-09-27)


### Bug Fixes

* better error if passing a scalar arg instead of kwargs ([7a47775](https://github.com/craigulliott/dsl_compose/commit/7a47775e7b13329c82c2497a017d2d67c5c56d75))

## [2.14.2](https://github.com/craigulliott/dsl_compose/compare/v2.14.1...v2.14.2) (2023-09-11)


### Bug Fixes

* freezing default arguments so that code within parsers can not modify the underlying values ([12674de](https://github.com/craigulliott/dsl_compose/commit/12674def81b7370f7e06b8036fea308dff95f30d))

## [2.14.1](https://github.com/craigulliott/dsl_compose/compare/v2.14.0...v2.14.1) (2023-09-11)


### Bug Fixes

* freezing dsl arguments so that other parts of the code can't change the underlying dsl configuration ([d3373d4](https://github.com/craigulliott/dsl_compose/commit/d3373d494b292241bc17f38e565a2434e5e0d187))

## [2.14.0](https://github.com/craigulliott/dsl_compose/compare/v2.13.1...v2.14.0) (2023-09-06)


### Features

* adding start_with/end_with and format validators to classes ([d390d15](https://github.com/craigulliott/dsl_compose/commit/d390d15bf2ebec2340815ff0a372a938072efd0e))

## [2.13.1](https://github.com/craigulliott/dsl_compose/compare/v2.13.0...v2.13.1) (2023-09-05)


### Bug Fixes

* fixed a nil value in error message caused by overwriting method argument ([dd7848b](https://github.com/craigulliott/dsl_compose/commit/dd7848b3861bff6176c8326f6784fb29f1ba2fdd))

## [2.13.0](https://github.com/craigulliott/dsl_compose/compare/v2.12.0...v2.13.0) (2023-09-04)


### Features

* optionally mark required arguments as keyword arguments ([9a1c901](https://github.com/craigulliott/dsl_compose/commit/9a1c90169fb36c550b0577034823579062120647))

## [2.12.0](https://github.com/craigulliott/dsl_compose/compare/v2.11.0...v2.12.0) (2023-09-02)


### Features

* adding dsl_name method to execution reader ([54e8a44](https://github.com/craigulliott/dsl_compose/commit/54e8a44b0f7a6fc2fe81a18cd53d3ebe76257348))

## [2.11.0](https://github.com/craigulliott/dsl_compose/compare/v2.10.0...v2.11.0) (2023-09-02)


### Features

* adding :dsl_execution to Parser's list of passable attributes ([ce0facb](https://github.com/craigulliott/dsl_compose/commit/ce0facb41edf46664c7fdf1b010b10f02d0f6902))

## [2.10.0](https://github.com/craigulliott/dsl_compose/compare/v2.9.0...v2.10.0) (2023-09-02)


### Features

* adding a `has_argument?` method to the DSL reader base class ([4a5db6a](https://github.com/craigulliott/dsl_compose/commit/4a5db6ab258283960fc909bdf46c75837475aa59))

## [2.9.0](https://github.com/craigulliott/dsl_compose/compare/v2.8.0...v2.9.0) (2023-08-31)


### Features

* adding rbs signatures to built gem so they are available in other projects ([1733e11](https://github.com/craigulliott/dsl_compose/commit/1733e1103921fd6724cf994ce430ef0f2a1f7806))


### Bug Fixes

* improving the rerun_all method so that the list of parsers to rerun does not depend on a parser having previously executed it's for_children_of method ([679d896](https://github.com/craigulliott/dsl_compose/commit/679d896c3efb2c5808b99f7fb996ca66f17d541d))

## [2.8.0](https://github.com/craigulliott/dsl_compose/compare/v2.7.0...v2.8.0) (2023-08-31)


### Features

* adding a rerun_all singleton method to re-execute all parsers in the system (useful from within specs) ([d0c4ee3](https://github.com/craigulliott/dsl_compose/commit/d0c4ee3cc41da45e774a17ab9d57990dbbf59603))

## [2.7.0](https://github.com/craigulliott/dsl_compose/compare/v2.6.1...v2.7.0) (2023-08-29)


### Features

* adding `namespace` and `title` methods to DSL generation. These help with documentation generation ([1bdf16d](https://github.com/craigulliott/dsl_compose/commit/1bdf16de6c1dc872809cc66d6599c36b3a1f1e99))

## [2.6.1](https://github.com/craigulliott/dsl_compose/compare/v2.6.0...v2.6.1) (2023-08-29)


### Bug Fixes

* renaming `description` to `add_documentation` for dynamically creating documentation from within parsers ([3e24194](https://github.com/craigulliott/dsl_compose/commit/3e2419492e61d94ea7d3c1f34ef4990fc0f6682a))

## [2.6.0](https://github.com/craigulliott/dsl_compose/compare/v2.5.2...v2.6.0) (2023-08-23)


### Features

* optionally request an object containing all the dsl and dsl method args from within the parser ([8abfd64](https://github.com/craigulliott/dsl_compose/commit/8abfd64131e37f620a9443466028c5a81b6f5377))

## [2.5.2](https://github.com/craigulliott/dsl_compose/compare/v2.5.1...v2.5.2) (2023-08-17)


### Bug Fixes

* optional array arguments default to empty arrays rather than nil ([8a74ad6](https://github.com/craigulliott/dsl_compose/commit/8a74ad671f5d74c3ab7deb6f09c2cfa7c3557d1c))

## [2.5.1](https://github.com/craigulliott/dsl_compose/compare/v2.5.0...v2.5.1) (2023-08-17)


### Bug Fixes

* defaulting optional boolean values to false instead of nil in the parser ([3a4b4d7](https://github.com/craigulliott/dsl_compose/commit/3a4b4d7df315e60dca0e66af37d77b800dc6be2c))
* stripping white space off descriptions ([93ba9d2](https://github.com/craigulliott/dsl_compose/commit/93ba9d21f57a4f58f70f24a44cd58121741da8d0))

## [2.5.0](https://github.com/craigulliott/dsl_compose/compare/v2.4.0...v2.5.0) (2023-08-01)


### Features

* you can call validators which accept arrays (such as `validate_in`) multiple times and they will be combined ([e1b4411](https://github.com/craigulliott/dsl_compose/commit/e1b441176768726cecd828e303781a57d4e36750))

## [2.4.0](https://github.com/craigulliott/dsl_compose/compare/v2.3.0...v2.4.0) (2023-07-31)


### Features

* access an ExecutionReader object from within a parser ([53e9c29](https://github.com/craigulliott/dsl_compose/commit/53e9c29073389217d8526c43eec67325587c45b9))

## [2.3.0](https://github.com/craigulliott/dsl_compose/compare/v2.2.2...v2.3.0) (2023-07-28)


### Features

* added a method_called? helper method to the DSL parser ([48e68a8](https://github.com/craigulliott/dsl_compose/commit/48e68a8d799e297d3433f3d2a6bccb7a077dd9af))

## [2.2.2](https://github.com/craigulliott/dsl_compose/compare/v2.2.1...v2.2.2) (2023-07-27)


### Bug Fixes

* argument type :float was not accepting values and did not have validations ([243eff1](https://github.com/craigulliott/dsl_compose/commit/243eff1d0d0cc48602cc626e8a91cdc45b4f9955))

## [2.2.1](https://github.com/craigulliott/dsl_compose/compare/v2.2.0...v2.2.1) (2023-07-27)


### Bug Fixes

* last_execution was raising error instead of returning nil  when no executions were found ([bedef1e](https://github.com/craigulliott/dsl_compose/commit/bedef1ec606801a4507ce77c39a33d14cb79818f))

## [2.2.0](https://github.com/craigulliott/dsl_compose/compare/v2.1.1...v2.2.0) (2023-07-27)


### Features

* Added a ReaderBase which can be extended to create custom reader classes. Also added dsl_used?, dsl_used_on_ancestors? and dsl_used_on_class_or_ancestors? helper methods to the Reader class ([6507e4a](https://github.com/craigulliott/dsl_compose/commit/6507e4a082c9a0d7e63c580a17bcb8eb2bd940ea))

## [2.1.1](https://github.com/craigulliott/dsl_compose/compare/v2.1.0...v2.1.1) (2023-07-26)


### Bug Fixes

* fixed bug where Execution classes were being returned from within the Reader but ExecutionReader classes were expected ([#56](https://github.com/craigulliott/dsl_compose/issues/56)) ([546cdaf](https://github.com/craigulliott/dsl_compose/commit/546cdaf323f3fc3be6ad09a47e5f99c3a59a50e2))

## [2.1.0](https://github.com/craigulliott/dsl_compose/compare/v2.0.1...v2.1.0) (2023-07-24)


### Features

* created a Reader class which can be used to access the resulting configuration from executing DSLs ([#53](https://github.com/craigulliott/dsl_compose/issues/53)) ([6e18eb7](https://github.com/craigulliott/dsl_compose/commit/6e18eb736611193b4fad8dac380cdd760095760f))

## [2.0.1](https://github.com/craigulliott/dsl_compose/compare/v2.0.0...v2.0.1) (2023-07-19)


### Bug Fixes

* ensuring the class is still defined and at the global Object scope, this prevents recently deleted classes from showing up before they have been garbage collected ([#51](https://github.com/craigulliott/dsl_compose/issues/51)) ([52111e3](https://github.com/craigulliott/dsl_compose/commit/52111e3647e8f9d26dcbea706dbe6977bf67c426))

## [2.0.0](https://github.com/craigulliott/dsl_compose/compare/v1.14.4...v2.0.0) (2023-07-19)


### ⚠ BREAKING CHANGES

* Removing dependency on ObjectSpace because of the problems it creates with garbage collection and test suites which dynamically create and destroy classes. This required bumping the minimum version of ruby to 3.1.4 ([#49](https://github.com/craigulliott/dsl_compose/issues/49))

### Bug Fixes

* Removing dependency on ObjectSpace because of the problems it creates with garbage collection and test suites which dynamically create and destroy classes. This required bumping the minimum version of ruby to 3.1.4 ([#49](https://github.com/craigulliott/dsl_compose/issues/49)) ([b63d8cf](https://github.com/craigulliott/dsl_compose/commit/b63d8cf9698dfc161cb910bd86e7f8d71961b9b1))

## [1.14.3](https://github.com/craigulliott/dsl_compose/compare/v1.14.2...v1.14.3) (2023-07-19)


### Bug Fixes

* for_children_of returns classes with dependencies before classes without any dependencies, this fixes a bug where the parser is used to create other classes, and classes with dependencies need to be created first ([#45](https://github.com/craigulliott/dsl_compose/issues/45)) ([ffc481d](https://github.com/craigulliott/dsl_compose/commit/ffc481d8cdcc85483bfc3829ac3eacd3f44ec657))

## [1.14.2](https://github.com/craigulliott/dsl_compose/compare/v1.14.1...v1.14.2) (2023-07-19)


### Bug Fixes

* fixed parser usage notes not being cleared as expected ([#43](https://github.com/craigulliott/dsl_compose/issues/43)) ([3d31ab1](https://github.com/craigulliott/dsl_compose/commit/3d31ab1a8dc238144749c18847d5e655461fca06))

## [1.14.1](https://github.com/craigulliott/dsl_compose/compare/v1.14.0...v1.14.1) (2023-07-19)


### Bug Fixes

* Clearing the parser_usage_notes when also clearing the DSLs. ([#41](https://github.com/craigulliott/dsl_compose/issues/41)) ([bbdb445](https://github.com/craigulliott/dsl_compose/commit/bbdb445ed9fa4b495f8aa5bf0b889707680858d0))

## [1.14.0](https://github.com/craigulliott/dsl_compose/compare/v1.13.1...v1.14.0) (2023-07-19)


### Features

* Parsers can push notes back to the DSLs to explain how each DSL is being used. These notes can be used in generated documentation. ([#39](https://github.com/craigulliott/dsl_compose/issues/39)) ([053fa50](https://github.com/craigulliott/dsl_compose/commit/053fa50bcbc2180b2f788b5a3bba11576804f206))

## [1.13.1](https://github.com/craigulliott/dsl_compose/compare/v1.13.0...v1.13.1) (2023-07-19)


### Bug Fixes

* unused optional arguments no longer raise an error within the parser ([#37](https://github.com/craigulliott/dsl_compose/issues/37)) ([99cd04b](https://github.com/craigulliott/dsl_compose/commit/99cd04b83387c7940e364dc86d527fdb51152405))

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
