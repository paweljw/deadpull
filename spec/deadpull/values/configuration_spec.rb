# frozen_string_literal: true

RSpec.describe Deadpull::Values::Configuration do
  include FakeFS::SpecHelpers

  subject { described_class.concretize(inline) }

  describe '.call' do
    context 'with empty inline config' do
      let(:inline) { {} }

      context 'with nil inline config' do
        it { expect(subject).to eq({}) }
      end

      context 'with {} inline' do
        let(:inline) { {} }
        it { expect(subject).to eq({}) }
      end

      context 'with current directory config' do
        before { fake_file pwd.join('.deadpull.yml'), 'path: "asdf/qwe"' }

        it { expect(subject).to eq(path: 'asdf/qwe') }
      end

      context 'with local config' do
        before { fake_file pwd.join('.deadpull.local.yml'), 'path: "asdf/zxc"' }

        it { expect(subject).to eq(path: 'asdf/zxc') }
      end
    end

    context 'with nonempty inline config' do
      let(:inline) { { inline: 'yes' } }

      context 'with full config stack without overwrites' do
        before do
          fake_file pwd.join('.deadpull.yml'), 'working: "yes"'
          fake_file pwd.join('.deadpull.local.yml'), 'local: "yes"'
        end

        it { expect(subject).to eq(inline: 'yes', working: 'yes', local: 'yes') }
      end

      context 'with full config stack with overwrites' do
        let(:inline) { { inline: 'yes', local: 'maybe' } }

        before do
          fake_file pwd.join('.deadpull.yml'), %(working: "yes")
          fake_file pwd.join('.deadpull.local.yml'), %(local: "yes"\nworking: "maybe")
        end

        it { expect(subject).to eq(inline: 'yes', working: 'maybe', local: 'maybe') }
      end
    end

    context 'with invalid syntax' do
      let(:inline) { {} }
      before { fake_file pwd.join('.deadpull.local.yml'), 'path: [:this, :those, :that]' }

      it { expect { subject }.to raise_error(Dry::Monads::UnwrapError) }
    end
  end
end
