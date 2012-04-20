class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.references :user
      t.text :key
      t.string :title
      t.string :identifier

      t.timestamps
    end
    add_index :keys, :user_id
  end
end
