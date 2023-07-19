# frozen_string_literal: true

require_relative "lib/dsl_compose/version"

Gem::Specification.new do |spec|
  spec.name = "dsl_compose"
  spec.version = DSLCompose::VERSION
  spec.authors = ["Craig Ulliott"]
  spec.email = ["craigulliott@gmail.com"]

  spec.summary = "Ruby gem to add dynamic DSLs to classes"
  spec.description = "Ruby gem to add dynamic DSLs to classes. DSLs are added to classes by including the DSLCompose module, and then calling the add_dsl singleton method within the class or a child class."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.4"

  spec.metadata["source_code_uri"] = "https://github.com/craigulliott/dsl_compose/"
  spec.metadata["changelog_uri"] = "https://github.com/craigulliott/dsl_compose/blob/main/CHANGELOG.md"

  spec.files = ["README.md", "LICENSE.txt", "CHANGELOG.md", "CODE_OF_CONDUCT.md"] + Dir["lib/**/*"]

  spec.require_paths = ["lib"]

  spec.add_development_dependency "class_spec_helper"
end
