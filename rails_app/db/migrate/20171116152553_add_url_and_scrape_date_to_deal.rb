class AddUrlAndScrapeDateToDeal < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :url, :string
    add_column :deals, :scraped_at, :datetime
    add_column :deals, :scrape_interval, :integer
  end
end
