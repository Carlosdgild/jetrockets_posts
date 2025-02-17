class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :login, null: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :users, :login, unique: true
    add_index :users, :deleted_at
  end
end
