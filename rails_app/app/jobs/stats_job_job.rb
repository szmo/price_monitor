class StatsJobJob < ApplicationJob
  queue_as :default

  @@graphite = GraphiteAdapter.new

  def perform(*args)
    @@graphite.send_raw({
      "stats.number_of_deals" => Deal.where(disabled_at: nil).count,
      "stats.number_of_users" => User.count
    })
    StatsJobJob.set(wait: 1.minute).perform_later
  end
end
