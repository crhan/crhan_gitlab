class UserProject < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  # attr_accessible :title, :body
end
