class CreateChatParticipations < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_participations do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :chat_participations, [ :chat_id, :participant_id ], unique: true
  end
end
