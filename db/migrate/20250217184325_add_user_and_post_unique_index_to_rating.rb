class AddUserAndPostUniqueIndexToRating < ActiveRecord::Migration[8.0]
  def change
    add_index :ratings, [:post_id, :user_id], unique: true, name: 'post_and_user_unique_index'
  end
end
