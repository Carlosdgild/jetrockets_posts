class AddUserIdAndIdIndexToPosts < ActiveRecord::Migration[8.0]
  def change
    add_index :posts, [:ip, :user_id], name: 'index_posts_on_ip_and_user_id'
  end
end
