class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_protected :admin
  # attr_accessible :title, :body
  has_many :user_projects, :dependent => :destroy
  has_many :projects, :through => :user_projects
  has_many :owns, :class_name => "Project", :foreign_key => :owner_id, :dependent => :nullify
  has_many :keys, :dependent => :destroy

  def is_admin?
    admin
  end

  def last_activity_project
    projects.first
  end

  def project_access
    self.user_projects.project_access
  end

  def self.not_in_project project
    in_user = project.users
    all_user = User.all
    all_user - in_user
  end

end
