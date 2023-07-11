# frozen_string_literal: true

module DSLCompose
  # This module is used to store shared configuration blocks which can be imported and
  # used within your base or method dsl configuration blocks.
  module SharedConfiguration
    class SharedConfigurationAlreadyExistsError < StandardError
    end

    class SharedConfigurationDoesNotExistError < StandardError
    end

    class InvalidSharedConfigurationNameError < StandardError
    end

    class NoBlockProvidedError < StandardError
    end

    # takes a name and a block and stores it in the shared_configuration hash
    # if a block with this name already exists, it raises an error
    def self.add name, &block
      raise InvalidSharedConfigurationNameError unless name.is_a?(Symbol)
      raise SharedConfigurationAlreadyExistsError if @shared_configuration&.key?(name)
      raise NoBlockProvidedError if block.nil?

      @shared_configuration ||= {}
      @shared_configuration[name] = block
    end

    # takes a name and returns the block stored in the shared_configuration hash
    # if a block with this name does not exist, it raises an error
    def self.get name
      raise InvalidSharedConfigurationNameError unless name.is_a?(Symbol)
      raise SharedConfigurationDoesNotExistError unless @shared_configuration&.key?(name)

      @shared_configuration[name]
    end

    # clears the shared_configuration hash, this is typically used from the test suite
    def self.clear
      @shared_configuration = {}
    end
  end
end
