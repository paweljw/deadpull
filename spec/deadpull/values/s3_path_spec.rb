# frozen_string_literal: true

RSpec.describe Deadpull::Values::S3Path do
  let(:local_root) { '/tmp' }
  let(:path) { '/tmp/file.txt' }
  let(:s3_prefix) { 'development' }

  subject { described_class.concretize(local_root, path, s3_prefix) }

  describe '#concretize' do
    it { expect(subject).to eq 'development/file.txt' }
  end
end
