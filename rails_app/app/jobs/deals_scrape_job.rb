class DealsScrapeJob < ApplicationJob
  queue_as :default

  @@graphite = GraphiteAdapter.new

  def perform(*args)
    # Do something later
    start_time = Time.now
    processed_deals = 0
    errors = 0
    deals_to_parse.each do |deal|
      begin
        new_deal = BasicParser.new(deal.url).parse
        deal_identifier = deal.name.parameterize
        send_deal_to_graphite(new_deal.price, Time.now - deal.updated_at, deal.scrape_interval, deal_identifier)
        deal.update!(price: new_deal.price, updated_at: Time.now)
        processed_deals += 1
      rescue
        errors += 1
      end
    end
    send_worker_stats_to_graphite(Time.now - start_time, processed_deals, errors)
    DealsScrapeJob.set(wait: 1.minute).perform_later
  end

  private

  def deals_to_parse
    Deal.where(disabled_at: nil).where('updated_at + scrape_interval < ?', Time.now)
  end

  def send_deal_to_graphite(deal_price, time_since_update, deal_scrape_interval, deal_identifier)
    @@graphite.send_raw({
      "deals.#{deal_identifier}.price" => deal_price,
      "deals.#{deal_identifier}.time_since_update" => time_since_update,
      "deals.#{deal_identifier}.smart_interval" => deal_scrape_interval,
    })
  end

  def send_worker_stats_to_graphite(worked_time, processed_deals, errors)
    @@graphite.send_raw({
      "deal_worker.work_time" => worked_time,
      "deal_worker.number_of_deals_processed" => processed_deals,
      "deal_worker.number_of_errors" => errors,
      "deal_worker.number_of_active_workers" => 1
    })
  end
end
