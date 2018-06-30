# frozen_string_literal: true

module Deadpull
  module Values
    class S3Locations < Base
      extend Dry::Initializer

      param :config
      param :environment

      def concretize
        OpenStruct.new(bucket: bucket, prefix: prefix)
      end

      private

      def bucket
        @bucket ||= config[:path].split('/')[0]
      end

      def prefix
        @prefix ||= (config[:path].split('/')[1..-1] + [environment]).reject(&:blank?).join('/')
      end
    end
  end
end
