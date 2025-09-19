class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :submitter, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :notifiable, null: false, polymorphic: true
      t.boolean :is_read, null: false, default: false
      t.timestamps
    end
  end
end
