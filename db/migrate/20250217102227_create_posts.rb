class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.string :ip, null: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :posts, :deleted_at
  end
end
