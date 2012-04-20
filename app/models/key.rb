class Key < ActiveRecord::Base
  belongs_to :user
  attr_accessible :identifier, :key, :title

  validates :key,
            :presence => true,
            :length => { :within => 0..255 }

  validates :title,
            :presence => true,
            :length => { :within => 0..255 }

  validate  :unique_key
  before_save :set_identifier
  before_validation :strip_white_space

  def strip_white_space
    self.key = self.key.strip unless self.key.blank?
  end

  def unique_key
    query = Key.where(:key => key)
    if (query.count > 0)
      errors.add :key, 'already exist.'
    end
  end

  def set_identifier
    self.identifier = "#{user.identifier}_#{Time.now.to_i}"
  end

end
