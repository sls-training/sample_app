class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relation, :follower_id
    add_index :relation, :followed_id
    add_index :relation, [:follower_id, followed_id], unique: true
  end
end
