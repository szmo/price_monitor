class RemoveScrapedAtFromDeals < ActiveRecord::Migration[5.1]
  def change
    remove_column :deals, :scraped_at, :datetime
  end
end
