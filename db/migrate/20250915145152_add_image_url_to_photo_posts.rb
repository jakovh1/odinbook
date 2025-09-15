class AddImageUrlToPhotoPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :photo_posts, :image_url, :string
  end
end
