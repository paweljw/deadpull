# frozen_string_literal: true

RSpec.describe Deadpull::Values::Base do
  subject { described_class.new.concretize }

  describe '#concretize' do
    it { expect { subject }.to raise_error(NotImplementedError) }
  end
end
