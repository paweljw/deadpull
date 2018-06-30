# frozen_string_literal: true

RSpec.describe Deadpull::Values::S3Client do
  let(:config) { { aws: { region: 'fakeregion' } } }
  subject { described_class.concretize(config) }

  describe '#concretize' do
    it { expect(subject).to be_a Aws::S3::Client }
  end
end
