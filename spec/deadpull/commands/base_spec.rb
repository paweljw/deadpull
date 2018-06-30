# frozen_string_literal: true

RSpec.describe Deadpull::Commands::Base do
  subject { described_class.call }

  describe '#call' do
    it { expect { subject }.to raise_error(NotImplementedError) }
  end
end
