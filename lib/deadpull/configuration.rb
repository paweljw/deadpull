# frozen_string_literal: true

require 'yaml'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/deep_merge'

module Deadpull
  class Configuration
    include Dry::Transaction

    HOME_PATH = File.expand_path('~/.config/deadpull.yml').freeze

    step :accept_inline_config
    step :working_directory_config
    step :local_config
    step :apply_inline_config

    def accept_inline_config(input)
      @inline_config = (input || {}).deep_symbolize_keys
      Success({})
    end

    def working_directory_config(input)
      transactionally_merge_input_with_file(input, current_working_path.join('.deadpull.yml'))
    end

    def local_config(input)
      transactionally_merge_input_with_file(input, current_working_path.join('.deadpull.local.yml'))
    end

    def apply_inline_config(input)
      Success(input.deep_merge(@inline_config))
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
