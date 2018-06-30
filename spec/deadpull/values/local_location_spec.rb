# frozen_string_literal: true

RSpec.describe Deadpull::Values::LocalLocation do
  include FakeFS::SpecHelpers

  let(:path) { '/' }
  let(:prefix) { 'test' }
  let(:key) { 'test/example/example.yml' }

  subject { described_class.concretize(path, prefix, key) }

  describe '#concretize' do
    it { expect(subject).to eq Pathname.new('/example/example.yml') }
  end
end
