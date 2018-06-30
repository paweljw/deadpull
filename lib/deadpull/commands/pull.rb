# frozen_string_literal: true

module Deadpull
  module Commands
    class Pull < S3Command
      extend Dry::Initializer

      param(:path, proc { |path| path.is_a?(Pathname) ? path : Pathname.new(File.expand_path(path)) })
      option :configuration, default: proc { Configuration.new({}).call.value! }
      option :environment, default: proc { Values::Environment.concretize }

      def call
        ensure_target_is_not_a_file
        objects.each do |object|
          location = Values::LocalLocation.concretize(path, s3_locations.prefix, object.key)
          object.download_file(location)
        end
        true
      end

      private

      def objects
        bucket.objects(prefix: s3_locations.prefix)
      end

      def ensure_target_is_not_a_file
        raise(ArgumentError, "#{path} is a regular file") if File.file?(path)
      end
    end
  end
end
