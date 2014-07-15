class CreatePosttousers < ActiveRecord::Migration
  def change
    create_table :posttousers do |t|
      t.integer :user_id
      t.integer :micropost_id

      t.timestamps
    end
    add_index :posttousers, :user_id
    add_index :posttousers, :micropost_id
    add_index :posttousers, [:user_id, :micropost_id], unique: true
  end
end
