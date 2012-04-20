class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_many :user_projects
  has_many :projects, :through => :user_projects
  has_many :keys, :dependent => :destroy

  def is_admin?
    admin
  end

  def identifier
    email.gsub /[@.]/, "_"
  end

  def last_activity_project
    projects.first
  end

end
