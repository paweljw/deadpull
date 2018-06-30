# frozen_string_literal: true

module Deadpull
  module Values
    class S3Client < Base
      extend Dry::Initializer

      param :config

      def concretize
        aws = config[:aws] || {}
        Aws::S3::Client.new(aws)
      end
    end
  end
end
