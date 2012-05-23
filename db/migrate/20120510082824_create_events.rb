class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :data
      t.integer :project_id
      t.integer :action
      t.integer :author_id

      t.timestamps
    end
  end
end
