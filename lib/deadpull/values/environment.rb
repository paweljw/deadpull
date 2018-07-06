# frozen_string_literal: true

module Deadpull
  module Values
    class Environment < Base
      extend Dry::Initializer

      param :environment, optional: true

      def concretize
        environment || ENV['DEADPULL_ENV'] || ENV['RAILS_ENV'] || 'development'
      end
    end
  end
end
