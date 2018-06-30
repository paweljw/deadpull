# frozen_string_literal: true

require 'rake'

RSpec.describe 'Deadpull Cap task' do
  let(:rake) { Rake::Application.new }

  before do
    Rake.application = rake
    Rake.application.rake_require('spec/support/fake_capistrano_dsl', [Dir.pwd])
    Rake.application.rake_require('lib/deadpull/capistrano/tasks/deadpull', [Dir.pwd])

    allow(Dir).to receive(:mktmpdir).and_yield('/fake_path')
    allow(Dir).to receive(:[]).and_return(['/fake_path/tmp.txt'])
  end

  subject { Rake::Task['deadpull:upload'] }

  describe 'runs' do
    it do
      expect(Deadpull::Configuration).to receive_message_chain(:new, :call, :value!).and_return({})
      expect(Deadpull::Commands::Pull).to receive(:call).with(instance_of(String), instance_of(Hash), 'test')
      expect(Deadpull::Values::RootRelativePath).to receive(:concretize).with('/fake_path', '/fake_path/tmp.txt')
      subject.invoke
    end
  end
end
