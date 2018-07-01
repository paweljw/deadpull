# frozen_string_literal: true

module Deadpull
  module Values
    class Configuration < Base
      extend Dry::Initializer

      param :inline_config, default: proc { {} }

      def concretize
        Builders::Configuration.new.with_step_args(
          inline_config: [inline_config]
        ).call({}).value!
      end
    end
  end
end
