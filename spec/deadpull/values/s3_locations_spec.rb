# frozen_string_literal: true

RSpec.describe Deadpull::Values::S3Locations do
  let(:config) { { path: 'bucket/prefix' } }
  let(:environment) { 'test' }

  subject { described_class.concretize(config, environment) }

  describe '#concretize' do
    it { expect(subject.bucket).to eq 'bucket' }
    it { expect(subject.prefix).to eq 'prefix/test' }
  end
end
