class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :gid
      t.decimal :share_price

      t.timestamps
    end
  end
end
