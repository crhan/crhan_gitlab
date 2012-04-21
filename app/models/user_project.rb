class UserProject < ActiveRecord::Base
  READER = 10
  WRITER = 20
  MASTER = 30
  belongs_to :user
  belongs_to :project
  # attr_accessible :title, :body
  attr_accessible :project_access, :user

  def self.access_roles
    {
      "reader" => READER,
      "writer" => WRITER,
      "master" => MASTER
    }
  end
end
