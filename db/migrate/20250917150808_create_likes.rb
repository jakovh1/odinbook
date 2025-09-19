class CreateLikes < ActiveRecord::Migration[8.0]
  def change
    drop_table :posts_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
    end

    create_table :likes do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :likes, [ :user_id, :post_id ], unique: true
  end
end
