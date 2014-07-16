class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag_name
      t.integer :micropost_id

      t.timestamps
    end
    add_index :tags, :tag_name
  end
end
