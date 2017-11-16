class CreateDeals < ActiveRecord::Migration[5.1]
  def change
    create_table :deals do |t|
      t.string :name,    null: false
      t.integer :price,  null: false
      t.string :country, default: nil
      t.string :city,    default: nil

      t.timestamps
    end
  end
end
