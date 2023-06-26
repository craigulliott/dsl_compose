module DSLCompose
  class Parser
    class BlockArguments
      def self.accepts_argument? arg_name, &block
        block.parameters.any? { |type, name| name == arg_name }
      end
    end
  end
end
