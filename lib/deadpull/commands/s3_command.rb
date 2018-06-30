# frozen_string_literal: true

module Deadpull
  module Commands
    class S3Command < Base
      private

      def s3_client
        @s3_client ||= Values::S3Client.concretize(configuration)
      end

      def s3_locations
        @s3_locations ||= Values::S3Locations.concretize(configuration, environment)
      end

      def bucket
        @bucket ||= Aws::S3::Bucket.new(s3_locations.bucket, client: s3_client)
      end
    end
  end
end
