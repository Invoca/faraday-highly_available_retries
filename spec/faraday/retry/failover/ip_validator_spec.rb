# frozen_string_literal: true

RSpec.describe Faraday::Retry::Failover::IpValidator do
  describe '.ip_addr?' do
    subject { described_class.ip_addr?(address) }

    context 'when the address is an ipv4 address' do
      let(:address) { '127.0.0.1' }

      it { is_expected.to be_truthy }
    end

    context 'when the address is an ipv6 address' do
      let(:address) { '::1' }

      it { is_expected.to be_truthy }
    end

    context 'when the address is not an ip address' do
      let(:address) { 'google.com' }

      it { is_expected.to be_falsey }
    end
  end
end
