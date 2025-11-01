class AddUuidToChats < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    add_column :chats, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_index :chats, :uuid, unique: true
  end
end
