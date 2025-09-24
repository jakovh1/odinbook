class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :content, null: false
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :chat, null: false, foreign_key: true
      t.boolean :is_read, null: false, default: false

      t.timestamps
    end
  end
end
