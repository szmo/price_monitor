require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GraphiteAdapter do
  before(:each) do
    allow(api_mock).to receive(:metrics)
    expect(GraphiteAPI).to receive(:new)
      .with(graphite: 'localhost:2003', prefix: 'price_monitor_internal')
      .and_return(api_mock)
    @graphite = GraphiteAdapter.new
  end

  let(:api_mock) { double :api_mock }

  describe '.initialize' do
    it 'instantiate GraphiteAdapter object and check if default values were loaded' do
      expect(@graphite.instance_variable_get('@graphite_host')).to eql('localhost')
      expect(@graphite.instance_variable_get('@default_period')).to eql('-14d')
      expect(@graphite.instance_variable_get('@api')).to eql(api_mock)
    end
  end

  describe '.send_raw' do
    it 'sends raw metric to graphite with value as key-word argument' do
      expect(api_mock).to receive(:metrics).with('mock.metric' => 123)
      @graphite.send_raw('mock.metric', value: 123)
    end

    it 'sends raw metric to graphite with additional time key-word ' do
      expect(api_mock).to receive(:metrics).with({ 'mock.metric' => 123 }, Time.at(999))
      @graphite.send_raw('mock.metric', value: 123, time: 999)
    end

    it 'sends raw metric to graphite with metric being hash with value and time as key-word' do
      expect(api_mock).to receive(:metrics).with({ 'mock.metric' => 123 }, Time.at(999))
      @graphite.send_raw({ 'mock.metric' => 123 }, { time: 999 })
    end

    it 'sends raw metric to graphite with metric being hash with value' do
      expect(api_mock).to receive(:metrics).with('mock.metric' => 123)
      @graphite.send_raw('mock.metric' => 123)
    end
  end

  describe '.send_deal_price' do
    it 'sends awesome_product deal to graphite basic way' do
      allow(Time).to receive(:now).and_return(123)
      expect(@graphite).to receive(:send_raw).with({
        'internal.awesome_product.price'      => 777,
        'internal.awesome_product.check_time' => 123,
      }, { time: nil })
      @graphite.send_deal_price('awesome_product', 777)
    end

    it 'sends awesome_product deal to graphite with time' do
      allow(Time).to receive(:now).and_return(123)
      expect(@graphite).to receive(:send_raw).with({
        'internal.awesome_product.price'      => 777,
        'internal.awesome_product.check_time' => 123,
      }, { time: 778 })
      @graphite.send_deal_price('awesome_product', 777, 778)
    end

    it 'sends awesome_product deal to graphite with diferrent user' do
      allow(Time).to receive(:now).and_return(123)
      expect(@graphite).to receive(:send_raw).with({
        'mock-user.awesome_product.price'      => 777,
        'mock-user.awesome_product.check_time' => 123,
      }, { time: 778 })
      @graphite.send_deal_price('awesome_product', 777, 778, 'mock-user')
    end
  end

  describe '.get_metric_url' do
    it 'checks if url contains mandatory query parts' do
      expect(@graphite.get_metric_url('mock.metric', 'mock-type').to_s).to include 'format=mock-type'
      expect(@graphite.get_metric_url('mock.metric', 'mock-type').to_s).to include 'target=mock.metric'
      expect(@graphite.get_metric_url('mock.metric', 'mock-type').to_s).to include 'to=now'
      expect(@graphite.get_metric_url('mock.metric', 'mock-type').to_s).to include 'from=-14d'
    end

    it 'checks time passing to url' do
      expect(@graphite.get_metric_url(
        'mock.metric', 'mock-type', time_from: '-2d', time_to: '-1d'
      ).to_s).to include 'to=-1d'
      expect(@graphite.get_metric_url(
        'mock.metric', 'mock-type', time_from: '-2d', time_to: '-1d'
      ).to_s).to include 'from=-2d'
    end
  end

  describe '.get_metric' do
    it 'fetches metric from graphite and checks json output being casted to hash' do
      mock_url = 'http://mock-graphite-host.mock:1911/mock-path'
      stub_request(:get, mock_url)
        .to_return(status: 200, body: '[{"target": "mock-target", "datapoints": [[null, 1], [1, 2], [2, 3]]}]')

      expect(@graphite).to receive(:get_metric_url)
        .with('mock.metric', 'mock-type', time_from: nil, time_to: nil)
        .and_return(URI.parse(mock_url))

      expect(@graphite.get_metric('mock.metric', 'mock-type')).to eql([[nil, 1], [1, 2], [2, 3]])
    end
  end

  describe '.get_metric_json' do
    it 'returns metrics in json' do
      mock_values = double('some-mock-values')
      expect(@graphite).to receive(:get_metric)
        .with('mock.metric', 'json', time_from: nil, time_to: nil)
        .and_return(mock_values)

      expect(@graphite.get_metric_json('mock.metric')).to eql(mock_values)
    end
  end

  describe '.get_metric_png' do
    it 'returns png image' do
      mock_values = double('some-mock-values')
      expect(@graphite).to receive(:get_metric)
        .with('mock.metric', 'png', time_from: nil, time_to: nil)
        .and_return(mock_values)

      expect(@graphite.get_metric_png('mock.metric')).to eql(mock_values)
    end
  end

  describe '.get_metric_png_url' do
    it 'returns url to png image' do
      mock_url = double('some-mock-url')
      expect(@graphite).to receive(:get_metric_url)
        .with('mock.metric', 'png', time_from: nil, time_to: nil)
        .and_return(mock_url)

      expect(@graphite.get_metric_png_url('mock.metric')).to eql(mock_url)
    end
  end
end
