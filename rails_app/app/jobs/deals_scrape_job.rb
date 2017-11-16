class DealsScrapeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    Deal.where(disabled_at: nil).each do |deal|
        new_deal_status = Settings.parser_helpers.join_parsers[deal.provider].constantize.new(deal.url)
    end
    DealsScrapeJob.set(wait: 1.minute).perform_later()
  end
end
