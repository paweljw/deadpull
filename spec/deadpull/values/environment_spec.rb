# frozen_string_literal: true

RSpec.describe Deadpull::Values::Environment do
  subject { described_class.concretize(environment) }
  let(:environment) { nil }

  describe '#concretize' do
    context 'with external value' do
      let(:environment) { 'test' }

      it { expect(subject).to eq 'test' }
    end

    context 'with DEADPULL_ENV' do
      before { ENV['DEADPULL_ENV'] = 'deadpull-env' }
      it { expect(subject).to eq 'deadpull-env' }
    end

    context 'with RAILS_ENV' do
      before do
        ENV['DEADPULL_ENV'] = nil
        @rails_env = ENV['RAILS_ENV']
        ENV['RAILS_ENV'] = 'rails-env'
      end

      after { ENV['RAILS_ENV'] = @rails_env }

      it { expect(subject).to eq 'rails-env' }
    end

    context 'with default fallback' do
      before do
        ENV['DEADPULL_ENV'] = nil
        @rails_env = ENV['RAILS_ENV']
        ENV['RAILS_ENV'] = nil
      end

      after { ENV['RAILS_ENV'] = @rails_env }

      it { expect(subject).to eq 'development' }
    end
  end
end
