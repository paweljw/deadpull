# frozen_string_literal: true

RSpec.describe Deadpull::Values::S3Client do
  let(:config) { { aws: { region: 'fakeregion' } } }

  subject { described_class.concretize(config) }
  
  let(:client) { double }

  before do
    allow(Aws::S3::Client).to receive(:new).and_return(client)
  end

  describe '#concretize' do
    it { expect(subject).to eq client }
  end
end
