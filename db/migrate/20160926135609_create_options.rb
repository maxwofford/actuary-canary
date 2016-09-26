class CreateOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :options do |t|
      t.references :stock, foreign_key: true
      t.date :expiration
      t.decimal :ask
      t.decimal :bid
      t.decimal :annualized_return
      t.decimal :return
      t.decimal :strike
      t.integer :volume

      t.timestamps
    end
  end
end
