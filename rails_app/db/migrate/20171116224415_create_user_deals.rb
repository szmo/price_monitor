class CreateUserDeals < ActiveRecord::Migration[5.1]
  def change
    create_table :user_deals do |t|
      t.integer :user_id
      t.integer :deal_id

      t.timestamps
    end

    add_index :user_deals, :user_id
    add_index :user_deals, :deal_id
  end
end
