# frozen_string_literal: true

module Deadpull
  module Values
    class LocalLocation < Base
      extend Dry::Initializer

      param(:path, proc { |path| path.is_a?(Pathname) ? path : Pathname.new(File.expand_path(path)) })
      param :prefix
      param :key

      def concretize
        create_local_directory unless local_directory_exists?
        local_path
      end

      private

      def local_path
        @local_path ||= path.join(key.sub(%r{\A#{prefix}?\/}, ''))
      end

      def local_dirname
        @local_dirname = File.dirname(local_path)
      end

      def local_directory_exists?
        Dir.exist?(local_dirname)
      end

      def create_local_directory
        FileUtils.mkdir_p(local_dirname)
      end
    end
  end
end
