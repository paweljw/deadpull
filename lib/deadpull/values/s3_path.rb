# frozen_string_literal: true

module Deadpull
  module Values
    class S3Path < Base
      extend Dry::Initializer

      param :local_root
      param :local_path
      param :s3_prefix

      def concretize
        [s3_prefix, local_path.sub(/\A#{local_root}?\//, '')].join('/')
      end
    end
  end
end
