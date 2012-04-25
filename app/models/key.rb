class Key < ActiveRecord::Base
  belongs_to :user
  attr_accessible :identifier, :key, :title

  validates :key,
            :presence => true,
            :length => { :within => 0..2000 }

  validates :title,
            :presence => true,
            :length => { :within => 0..255 }

  validate  :unique_key
  before_save :set_identifier
  before_validation :strip_white_space
  before_destroy :del_key
  before_create :update_repository


  private

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
    self.identifier = "#{Time.now.to_i}"
  end

  def update_repository
    CrhanGit::CrhanGit.new.add_key(self)
  end

  def del_key
    CrhanGit::CrhanGit.new.del_key(self)
  end
end
