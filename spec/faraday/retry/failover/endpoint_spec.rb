# frozen_string_literal: true

RSpec.describe Faraday::Retry::Failover::Endpoint do
  describe '.from_host_and_port' do
    subject(:endpoints) { described_class.from_host_and_port(host, port) }

    let(:host) { 'google.com' }
    let(:port) { 80 }

    before { allow(Socket).to receive(:getaddrinfo).with(host, nil, Socket::AF_INET, Socket::SOCK_STREAM).and_return(expected_resolves) }

    context 'when the host does not resolve' do
      let(:expected_resolves) { nil }

      it { expect { endpoints }.to raise_error(described_class::DNSResolutionError, "getaddrinfo(#{host}) failed") }
    end

    context 'when the host resolves to no ips' do
      let(:expected_resolves) { [] }

      it { expect { endpoints }.to raise_error(described_class::DNSResolutionError, "No IP addrs returned from #{host}") }
    end

    context 'when the host is a string and resolves to a single ip' do
      let(:expected_resolves) { [["AF_INET", 0, "142.251.209.142", "142.251.209.142", 2, 1, 6]] }

      it { is_expected.to eq([described_class.new("142.251.209.142", port, hostname: host)]) }
    end

    context 'when the host is a string and resolves to multiple ips' do
      let(:expected_resolves) { [["AF_INET", 0, "142.251.209.142", "142.251.209.142", 2, 1, 6], ["AF_INET", 0, "142.251.209.143", "142.251.209.143", 2, 1, 6]] }

      it { is_expected.to eq([described_class.new("142.251.209.142", port, hostname: host), described_class.new("142.251.209.143", port, hostname: host)]) }
    end

    context 'when the host is an ip address' do
      let(:host)              { "142.251.209.142" }
      let(:expected_resolves) { [["AF_INET", 0, "142.251.209.142", "142.251.209.142", 2, 1, 6]] }

      it { is_expected.to eq([described_class.new("142.251.209.142", port)]) }
    end
  end
end
