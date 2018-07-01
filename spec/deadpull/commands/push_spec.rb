# frozen_string_literal: true

RSpec.describe Deadpull::Commands::Push do
  include FakeFS::SpecHelpers

  let(:path) { '/' }
  let(:configuration) { { path: 'test-bucket/some-test' } }
  let(:environment) { 'test' }

  subject { described_class.new(path, configuration, environment) }

  let(:client) { double('client') }
  let(:bucket) { double('bucket') }

  before do
    fake_file '/tmp.txt', 'not important'
    allow(Aws::S3::Client).to receive(:new).and_return(client)
    allow(Aws::S3::Bucket).to receive(:new).and_return(bucket)
  end

  describe '#call' do
    after { subject.call }

    context 'with path specified' do
      before do
        # Work around https://github.com/fakefs/fakefs/issues/332
        allow(Dir).to receive(:[]).and_return(['/tmp.txt'])
      end

      it { expect(bucket).to receive(:put_object).with(key: 'some-test/test/tmp.txt', body: 'not important') }
    end

    context 'with single file specified' do
      let(:path) { '/tmp.txt' }
      it { expect(bucket).to receive(:put_object).with(key: 'some-test/test/tmp.txt', body: 'not important') }
    end
  end
end
