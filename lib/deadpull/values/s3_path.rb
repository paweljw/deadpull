# frozen_string_literal: true

module Deadpull
  module Values
    class S3Path < Base
      extend Dry::Initializer

      param :local_root
      param :local_path
      param :s3_prefix

      def concretize
        [s3_prefix, RootRelativePath.concretize(local_root, local_path)].join('/')
      end
    end
  end
end
