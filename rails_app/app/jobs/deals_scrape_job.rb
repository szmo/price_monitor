class DealsScrapeJob < ApplicationJob
  queue_as :default

  @@graphite = GraphiteAdapter.new

  def perform(*args)
    # Do something later
    start_time = Time.now
    processed_deals = 0
    errors = 0
    deals_to_parse.each do |deal|
      # new_deal_status = Settings.parser_helpers.join_parsers[deal.provider].constantize.new(deal.url)
      begin
        if deal.updated_at.nil? or deal.updated_at + deal.scrape_interval < Time.now
          new_deal = BasicParser.new(deal.url).parse
          deal_identifier = Digest::MD5.hexdigest(deal.url)
          @@graphite.send_raw({
            "deals.#{deal_identifier}.price" => new_deal.price,
            "deals.#{deal_identifier}.time_since_update" => (Time.now - deal.updated_at),
            "deals.#{deal_identifier}.smart_interval" => deal.scrape_interval,
          })
          deal.update!(price: new_deal.price, updated_at: Time.now)
          processed_deals = processed_deals + 1
        end
      rescue
        errors = errors + 1
      end
    end
    @@graphite.send_raw({
      "deal_worker.work_time" => (Time.now - start_time),
      "deal_worker.number_of_deals_processed" => processed_deals,
      "deal_worker.number_of_errors" => errors,
      "deal_worker.number_of_active_workers" => 1
    })
    DealsScrapeJob.set(wait: 1.minute).perform_later
  end

  private

  def deals_to_parse
    Deal.where(disabled_at: nil).find_in_batches(batch_size: 1000)
  end
end
