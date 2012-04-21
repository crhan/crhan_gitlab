
class Project < ActiveRecord::Base
  attr_accessible :description, :name, :path

  has_many :user_projects
  has_many :users, :through => :user_projects
  belongs_to :owner, :class_name => 'User'

  validates :name,
            :uniqueness => true,
            :presence => true,
            :length => { :within => 1..255 }

  validates :path,
            :uniqueness => true,
            :presence => true,
            :format => { :with => /^[a-zA-Z0-9_\-\.]*$/,
                         :message => "only letters, digits & '-' '_' '.' are allowed" },
            :length => { :within => 1..255 }

  validates :description,
            :length => { :within => 0..2000 }

  validates :owner, :presence => true

  #before_save :checkout_gitolite_admin

  def update_repository
    CrhanGit::CrhanGit.new.update_repo(self)
  end

  def repo_reader
    self.users.where("project_access = ?",UserProject::READER)
  end

  def repo_writer
    self.users.where("project_access = ?",UserProject::WRITER)
  end

  def repo_master
    self.owner
  end

end
