# frozen_string_literal: true

require 'rake'

RSpec.describe 'Deadpull Cap task' do
  let(:rake) { Rake::Application.new }

  before do
    Rake.application = rake
    Rake.application.rake_require('spec/support/fake_capistrano_dsl', [Dir.pwd])
    Rake.application.rake_require('lib/capistrano/tasks/deadpull', [Dir.pwd])

    allow(Dir).to receive(:mktmpdir).and_yield('/fake_path')
    allow(Dir).to receive(:[]).and_return(['/fake_path/tmp.txt'])
  end

  subject { Rake::Task['deadpull:upload'] }

  describe 'runs' do
    after { subject.invoke }

    it do
      expect(Deadpull::Values::Configuration).to receive(:concretize).with({}).and_return({})
      expect(Deadpull::Commands::Pull).to receive(:call).with(instance_of(String), instance_of(Hash), 'test')
    end
  end
end
