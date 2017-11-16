class AddIndexesToDeals < ActiveRecord::Migration[5.1]
  def change
    add_index :deals, :disabled_at
    add_index :deals, :url
    add_index :deals, :provider
  end
end
