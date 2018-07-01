# frozen_string_literal: true

RSpec.describe Deadpull::Commands::Pull do
  include FakeFS::SpecHelpers

  let(:path) { '/' }
  let(:configuration) { { path: 'test-bucket/some-test' } }
  let(:environment) { 'test' }

  subject { described_class.new(path, configuration, environment) }

  let(:object) { double(key: 'some-test/test/tmp.txt', download_file: true) }
  let(:client) { double('client') }
  let(:bucket) { double('bucket', objects: [object]) }

  before do
    allow(Aws::S3::Client).to receive(:new).and_return(client)
    allow(Aws::S3::Bucket).to receive(:new).and_return(bucket)
  end

  describe '#call' do
    context 'with path specified' do
      after { subject.call }
      it { expect(object).to receive(:download_file).with(Pathname.new('/tmp.txt')) }
    end

    context 'with single file specified' do
      before { fake_file '/tmp.txt', 'not_important' }

      let(:path) { '/tmp.txt' }

      it { expect { subject.call }.to raise_error(ArgumentError) }
    end
  end
end
