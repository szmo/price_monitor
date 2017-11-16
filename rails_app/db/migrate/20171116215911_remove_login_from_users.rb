class RemoveLoginFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_index  :users, :login
    remove_column :users, :login, :string
  end
end
