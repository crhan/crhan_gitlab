class Project < ActiveRecord::Base
  attr_accessible :description, :name, :owner_id, :path
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
            :format => { :with => /^[a-zA-Z0-9_\-\.]*%/,
                         :message => "only letters, digits & '-' '_' '.' are allowed" },
            :length => { :within => 1..255 }

  validates :description,
            :length => { :within => 0..2000 }

  validates :owner, :presence => true
end
