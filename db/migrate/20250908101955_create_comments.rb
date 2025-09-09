class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_check_constraint :comments,
                         "length(content) BETWEEN 1 AND 40000",
                         name: "content_length_between_1_and_40000"
  end
end
