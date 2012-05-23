class Event < ActiveRecord::Base
  default_scope where("author_id IS NOT NULL")
  default_scope order("created_at DESC")
  attr_accessible :project, :action, :data, :author_id

  Created   = 1
  Updated   = 2
  Pushed    = 3
  Commented = 4

  belongs_to :project

  serialize :data

  scope :recent, order("created_at DESC")
  scope :code_push, where(:action => Pushed)

  def self.determine_action(record)
    if [Issue, MergeRequest].include? record.class
      Event::Created
    elsif record.kind_of? Note
      Event::Commented
    end
  end

  # Next events currently enabled for system
  #  - push 
  #  - new issue
  #  - merge request
  def allowed?
    push?
  end

  def create?
    action == self.class::Created
  end

  def update?
    action == self.class::Updated
  end

  def push?
    action == self.class::Pushed
  end

  def new_tag?
    data[:ref]["refs/tags"]
  end

  def new_branch?
    data[:before] =~ /^00000/
  end

  def commit_from
    data[:before]
  end

  def commit_to
    data[:after]
  end

  def branch_name
    @branch_name ||= data[:ref].gsub("refs/heads/", "")
  end

  def tag_name
    @tag_name ||= data[:ref].gsub("refs/tags/", "")
  end

  def author
    @author ||= User.find(author_id)
  end

  def commits
    @commits ||= data[:commits].map do |commit|
      project.commit(commit[:id])
    end
  end

  delegate :email, :to => :author, :prefix => true, :allow_nil => true
  delegate :name, :to => :project, :prefix => true
end
# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  target_type :string(255)
#  target_id   :integer
#  title       :string(255)
#  data        :text
#  project_id  :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  action      :integer
#


