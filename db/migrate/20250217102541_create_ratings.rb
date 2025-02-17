class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings do |t|
      t.references :post, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.datetime :deleted_at
      t.integer :value, null: false
      t.timestamps
    end
    add_check_constraint :ratings, 'value BETWEEN 1 AND 5', name: 'value_range_check'
    add_index :ratings, :deleted_at
  end
end
