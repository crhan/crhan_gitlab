class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :path
      t.text :description
      t.integer :owner_id

      t.timestamps
    end
  end
end
