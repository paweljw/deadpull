# frozen_string_literal: true

module Deadpull
  module Values
    class Base
      def self.concretize(*args)
        new(*args).concretize
      end

      def concretize
        raise NotImplementedError, "implement `concretize` for #{self.class.name}"
      end
    end
  end
end
