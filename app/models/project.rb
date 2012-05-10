
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

  before_destroy :del_repo
  before_save :update_path

  #before_save :checkout_gitolite_admin

  def update_repository
    CrhanGit::CrhanGit.new.update_repo(self)
  end

  def del_repo
    CrhanGit::CrhanGit.new.del_repo(self)
  end

  def repo_reader
    self.users.where("project_access = ?",UserProject::READER)
  end

  def repo_writer
    self.users.where("project_access = ?",UserProject::WRITER)
  end

  def repo_master
    self.users.where("project_access = ?",UserProject::MASTER)
  end

  def self.access_options
    UserProject.access_roles
  end

  private
  def update_path
    self.path = self.name.gsub(/\s+/,"_").downcase
  end

end
