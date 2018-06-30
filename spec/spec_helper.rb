# frozen_string_literal: true

require 'bundler/setup'

if %w[1 true].include?(ENV['CI'] || ENV['COVERAGE'])
  require 'simplecov'
  SimpleCov.start
end

ENV['DEADPULL_ENV'] ||= 'test'

require 'deadpull'
require 'pry'

require 'fakefs/spec_helpers'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  Dir['./spec/support/**/*.rb'].each { |file| require file }

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
