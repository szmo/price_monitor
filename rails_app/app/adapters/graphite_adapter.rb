require 'net/http'
require 'json'
require 'graphite-api'

class GraphiteAdapter
  def initialize
    @graphite_host = Settings.graphite.host
    @default_period = Settings.graphite.default_get_metric_time
    @api = GraphiteAPI.new(
      graphite: "#{@graphite_host}:#{Settings.graphite.port}",
      prefix: Settings.graphite.metric_prefix
    )
  end

  def send_raw(metric, value: nil, time: nil)
    metric = { metric => value } unless metric.is_a?(Hash)
    time.nil? ? @api.metrics(metric) : @api.metrics(metric, Time.at(time))
  end

  def send_deal_price(deal_name, price, time = nil, user = 'internal')
    metrics_hash = {
      "#{user}.#{deal_name}.price" => price,
      "#{user}.#{deal_name}.check_time" => Time.now
    }
    send_raw(metrics_hash, time: time)
  end

  def get_metric_url(metric, type, time_from: nil, time_to: nil)
    URI::HTTP.build({
      host: @graphite_host,
      path: '/render',
      port: Settings.graphite.http_port,
      query: {
        target: metric,
        format: type,
        from: time_from ? time_from : @default_period,
        to: time_to ? time_to : 'now'
      }.to_query
    })
  end
  
  def get_metric(metric, type, time_from: nil, time_to: nil)
    url = get_metric_url(metric, type, time_from: time_from, time_to: time_to)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    JSON.parse(res.body)[0]['datapoints']
  end

  def get_metric_json(metric, time_from: nil, time_to: nil)
    get_metric(metric, 'json', time_from: time_from, time_to: time_to)
  end

  def get_metric_png(metric, time_from: nil, time_to: nil)
    get_metric(metric, 'png', time_from: time_from, time_to: time_to)
  end

  def get_metric_png_url(metric, time_from: nil, time_to: nil)
    get_metric_url(metric, 'png', time_from: nil, time_to: nil)
  end
end
