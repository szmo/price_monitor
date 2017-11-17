class AddUserDealsIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_deal_id, :integer
    add_index  :users, :user_deal_id
  end
end
