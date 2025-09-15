class AddPostableIdAndPostableTypeToPosts < ActiveRecord::Migration[8.0]
  def change
    add_reference :posts, :postable, polymorphic: true, null: false
  end
end
