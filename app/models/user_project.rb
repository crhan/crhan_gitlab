class UserProject < ActiveRecord::Base
  READER = 10
  WRITER = 20
  MASTER = 30
  belongs_to :user
  belongs_to :project
  # attr_accessible :title, :body
  attr_protected :project_id, :project
  after_destroy :del_dep

  def self.access_roles
    {
      "Reader" => READER,
      "Writer" => WRITER,
      "Master" => MASTER
    }
  end

  def del_dep
    CrhanGit::CrhanGit.new.update_repo(self.project)
  end

end
