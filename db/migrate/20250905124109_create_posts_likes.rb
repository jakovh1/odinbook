class CreatePostsLikes < ActiveRecord::Migration[8.0]
  def change
    create_table :posts_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.index [ :user_id, :post_id ], unique: true
    end
  end
end
