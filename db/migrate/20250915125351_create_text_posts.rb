class CreateTextPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :text_posts do |t|
      t.string :content, null: false
      t.timestamps
    end
  end
end
