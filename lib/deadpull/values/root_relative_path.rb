# frozen_string_literal: true

module Deadpull
  module Values
    class RootRelativePath < Base
      extend Dry::Initializer

      param :root
      param :path

      def concretize
        path.sub(%r{\A#{root}?\/}, '')
      end
    end
  end
end
