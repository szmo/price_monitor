class DealsScrapeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    deals_to_parse.each do |deal|
      # new_deal_status = Settings.parser_helpers.join_parsers[deal.provider].constantize.new(deal.url)
      new_deal = BasicParser.new(deal.url).parse
      deal.update!(price: new_deal.price, updated_at: Time.now)

    end
    DealsScrapeJob.set(wait: 1.minute).perform_later
  end

  private

  def deals_to_parse
    Deal.where(disabled_at: nil)
  end
end
