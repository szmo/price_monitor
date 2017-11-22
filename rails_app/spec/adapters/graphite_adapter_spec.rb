require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GraphiteAdapter do
  describe '.initialize' do
    context 'create_object' do
      let(:api_mock) { double :api_mock }

      before(:each) do
        allow(api_mock).to receive(:metrics)
        expect(GraphiteAPI).to receive(:new)
          .with(graphite: 'localhost:2003', prefix: 'price_monitor_internal')
          .and_return(api_mock)
        @graphite = GraphiteAdapter.new
      end

      it 'returns_ready_api_handler' do
        expect(@graphite.instance_variable_get('@graphite_host')).to eql('localhost')
        expect(@graphite.instance_variable_get('@default_period')).to eql('-14d')
        expect(@graphite.instance_variable_get('@api')).to eql(api_mock)
      end

      it 'sends_raw_metic_basic_case' do
        expect(api_mock).to receive(:metrics).with('mock.metric' => 123)
        @graphite.send_raw('mock.metric', value: 123)
      end

      it 'sends_raw_metric_with_time' do
        expect(api_mock).to receive(:metrics).with({ 'mock.metric' => 123 }, Time.at(999))
        @graphite.send_raw('mock.metric', value: 123, time: 999)
      end

      it 'sends_raw_metric_with_time_and_hash' do
        expect(api_mock).to receive(:metrics).with({ 'mock.metric' => 123 }, Time.at(999))
        @graphite.send_raw({ 'mock.metric' => 123 }, { time: 999 })
      end

      it 'sends_raw_metric_without_time_and_with_hash' do
        expect(api_mock).to receive(:metrics).with('mock.metric' => 123)
        @graphite.send_raw('mock.metric' => 123)
      end

      it 'sends_deal_price_basic_case' do
        allow(Time).to receive(:now).and_return(123)
        expect(@graphite).to receive(:send_raw).with({
          'internal.awesome_product.price'      => 777,
          'internal.awesome_product.check_time' => 123,
        }, { time: nil })
        @graphite.send_deal_price('awesome_product', 777)
      end

      it 'sends_deal_price_with_time' do
        allow(Time).to receive(:now).and_return(123)
        expect(@graphite).to receive(:send_raw).with({
          'internal.awesome_product.price'      => 777,
          'internal.awesome_product.check_time' => 123,
        }, { time: 778 })
        @graphite.send_deal_price('awesome_product', 777, 778)
      end

      it 'sends_deal_price_with_time_and_user' do
        allow(Time).to receive(:now).and_return(123)
        expect(@graphite).to receive(:send_raw).with({
          'mock-user.awesome_product.price'      => 777,
          'mock-user.awesome_product.check_time' => 123,
        }, { time: 778 })
        @graphite.send_deal_price('awesome_product', 777, 778, 'mock-user')
      end

      it 'gets_metrics_url_basic_case' do
        expect(@graphite.get_metric_url('mock.metric', 'mock-type').to_s).to include 'format=mock-type'
        expect(@graphite.get_metric_url('mock.metric', 'mock-type').to_s).to include 'target=mock.metric'
        expect(@graphite.get_metric_url('mock.metric', 'mock-type').to_s).to include 'to=now'
        expect(@graphite.get_metric_url('mock.metric', 'mock-type').to_s).to include 'from=-14d'
      end

      it 'gets_metrics_url_time_to_from' do
        expect(@graphite.get_metric_url(
          'mock.metric', 'mock-type', time_from: '-2d', time_to: '-1d'
        ).to_s).to include 'to=-1d'
        expect(@graphite.get_metric_url(
          'mock.metric', 'mock-type', time_from: '-2d', time_to: '-1d'
        ).to_s).to include 'from=-2d'
      end

      it 'fetches_metric_with_defined_type' do
        mock_url = 'http://mock-graphite-host.mock:1911/mock-path'
        stub_request(:get, mock_url)
          .to_return(status: 200, body: '[{"target": "mock-target", "datapoints": [[null, 1], [1, 2], [2, 3]]}]')

        expect(@graphite).to receive(:get_metric_url)
          .with('mock.metric', 'mock-type', time_from: nil, time_to: nil)
          .and_return(URI.parse(mock_url))

        expect(@graphite.get_metric('mock.metric', 'mock-type')).to eql([[nil, 1], [1, 2], [2, 3]])
      end

      it 'gets_metric_with_json_format' do
        mock_values = double('some-mock-values')
        expect(@graphite).to receive(:get_metric)
          .with('mock.metric', 'json', time_from: nil, time_to: nil)
          .and_return(mock_values)

        expect(@graphite.get_metric_json('mock.metric')).to eql(mock_values)
      end

      it 'gets_metric_with_png_format' do
        mock_values = double('some-mock-values')
        expect(@graphite).to receive(:get_metric)
          .with('mock.metric', 'png', time_from: nil, time_to: nil)
          .and_return(mock_values)

        expect(@graphite.get_metric_png('mock.metric')).to eql(mock_values)
      end

      it 'gets_metric_url_with_png_format' do
        mock_url = double('some-mock-url')
        expect(@graphite).to receive(:get_metric_url)
          .with('mock.metric', 'png', time_from: nil, time_to: nil)
          .and_return(mock_url)

        expect(@graphite.get_metric_png_url('mock.metric')).to eql(mock_url)
      end
    end
  end
end
