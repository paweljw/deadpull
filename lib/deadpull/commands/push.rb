# frozen_string_literal: true

module Deadpull
  module Commands
    class Push < S3Command
      extend Dry::Initializer

      param(:path, proc { |path| path.is_a?(Pathname) ? path : Pathname.new(File.expand_path(path)) })
      param :configuration, default: proc { Values::Configuration.concretize }
      param :environment, default: proc { Values::Environment.concretize }

      def call
        paths.each do |current_path|
          bucket.put_object(
            key: Values::S3Path.concretize(local_root, current_path, s3_locations.prefix),
            body: File.read(current_path)
          )
        end
        true
      end

      private

      def paths
        @paths ||= if File.file?(path)
                     [path]
                   else
                     Dir[path.join('**', '*')]
                   end
      end

      def local_root
        @local_root ||= File.file?(path) ? File.dirname(path) : path
      end
    end
  end
end
