class AddAttributesToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :content, :string
    add_reference :posts, :author, null: false, foreign_key: { to_table: :users }

    add_index :posts, :created_at
  end
end
