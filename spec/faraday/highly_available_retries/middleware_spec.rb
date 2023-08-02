# frozen_string_literal: true

RSpec.describe Faraday::HighlyAvailableRetries::Middleware do
  describe '#on_request' do
    subject(:on_request) { middleware.on_request(env) }

    let(:middleware)      { described_class.new(app) }
    let(:app)             { instance_double(Faraday::Adapter::NetHttp, call: nil) }
    let(:env)             { Faraday::Env.from(url: url, request: request, request_headers: request_headers) }
    let(:request)         { Faraday::RequestOptions.new }
    let(:request_headers) { {} }
    let(:url)             { URI('http://google.com') }

    before do
      allow(Faraday::HighlyAvailableRetries::Endpoint).to(
        receive(:from_host_and_port)
          .with('google.com', 80)
          .and_return([
                        Faraday::HighlyAvailableRetries::Endpoint.new('127.0.0.1', 80, hostname: 'google.com'),
                        Faraday::HighlyAvailableRetries::Endpoint.new('127.0.0.2', 80, hostname: 'google.co.uk'),
                      ])
      )
    end

    context 'when the request resolves multiple endpoints and is on the first attempt' do
      it { expect { on_request }.to change(url, :hostname).from('google.com').to('127.0.0.1') }
      it { expect { on_request }.to change(env, :request_headers).from({}).to({ 'Host' => 'google.com:80' }) }
    end

    context 'when the request resolves multiple endpoints and is on the first retry' do
      before do
        middleware.on_request(env)
        env[:response] = instance_double(Faraday::Response)
      end

      it { expect { on_request }.to change(url, :hostname).from('127.0.0.1').to('127.0.0.2') }
      it { expect { on_request }.to change(env, :request_headers).from({ 'Host' => 'google.com:80' }).to({ 'Host' => 'google.co.uk:80' }) }
    end
  end
end
