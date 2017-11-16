class AddProviderToDeals < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :provider, :string
  end
end
