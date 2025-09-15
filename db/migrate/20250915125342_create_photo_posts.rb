class CreatePhotoPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :photo_posts do |t|
      t.string :caption
      t.timestamps
    end
  end
end
