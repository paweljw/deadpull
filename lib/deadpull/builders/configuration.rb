# frozen_string_literal: true

require 'yaml'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/deep_merge'

module Deadpull
  module Builders
    class Configuration
      include Dry::Transaction

      HOME_PATH = File.expand_path('~/.config/deadpull.yml').freeze

      step :working_directory_config
      step :local_config
      step :inline_config

      def working_directory_config(input)
        transactionally_merge_input_with_file(input, current_working_path.join('.deadpull.yml'))
      end

      def local_config(input)
        transactionally_merge_input_with_file(input, current_working_path.join('.deadpull.local.yml'))
      end

      def inline_config(input, inline_config)
        Success(input.deep_merge(inline_config))
      end

      private

      def current_working_path
        @current_working_path ||= Pathname.new(Dir.pwd).freeze
      end

      def transactionally_merge_input_with_file(input, file)
        output = if File.exist?(file)
                   YAML.load_file(file).deep_symbolize_keys
                 else
                   {}
                 end
        Success(input.deep_merge(output))
      rescue Psych::SyntaxError => error
        Failure(error)
      end
    end
  end
end
