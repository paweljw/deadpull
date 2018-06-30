# frozen_string_literal: true

module Deadpull
  module Commands
    class Base
      def self.call(*args)
        new(*args).call
      end

      def call
        raise NotImplementedError, "implement `call` for #{self.class.name}"
      end
    end
  end
end
