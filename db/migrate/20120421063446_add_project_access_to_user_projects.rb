class AddProjectAccessToUserProjects < ActiveRecord::Migration
  def change
    add_column :user_projects, :project_access, :integer, :default => 0
  end
end
