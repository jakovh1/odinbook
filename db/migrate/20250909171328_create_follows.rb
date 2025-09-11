class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followee, null: false, foreign_key: { to_table: :users }
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :follows, [ :follower_id, :followee_id ], unique: true
    add_index :follows, [ :followee_id, :status ]
    add_index :follows, [ :follower_id, :status ]

    add_check_constraint :follows, "status IN ('pending', 'accepted', 'blocked')", name: "status_check"
  end
end
