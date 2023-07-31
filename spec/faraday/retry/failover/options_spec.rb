# frozen_string_literal: true

RSpec.describe Faraday::Retry::Failover::Options do
  let(:arguments) { {} }
  let(:options)   { described_class.from(arguments) }

  describe '#default_port' do
    subject { options.default_port }

    context 'when configured with an explicit default port' do
      let(:arguments) { { default_port: 1234 } }

      it { is_expected.to eq(1234) }
    end

    context 'when not configured with an explicit default port' do
      it { is_expected.to eq(80) }
    end
  end

  describe '#hosts' do
    subject { options.hosts }

    context 'when configured without any hosts' do
      let(:arguments) { { hosts: nil } }

      it { is_expected.to eq([]) }
    end

    context 'when configured with a single host as a string' do
      let(:arguments) { { hosts: 'google.com' } }

      it { is_expected.to eq([['google.com', 80]]) }
    end

    context 'when configured with a single host as an array' do
      let(:arguments) { { hosts: ['google.com'] } }

      it { is_expected.to eq([['google.com', 80]]) }
    end

    context 'when configured with multiple hosts' do
      let(:arguments) { { hosts: ['google.com', 'google.co.uk:443'] } }

      it { is_expected.to eq([['google.com', 80], ['google.co.uk', 443]]) }
    end
  end
end
