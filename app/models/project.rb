class Project < ActiveRecord::Base
  attr_accessible :description, :name, :path
  attr_accessor :current_user_id

  has_many :user_projects
  has_many :users, :through => :user_projects
  has_many :events, :dependent => :destroy
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
  before_validation :update_path
  after_create :event_create
  after_update :event_update

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

  def observe_push(oldrev, newrev, ref, committer_email)
    data = web_hook_data(oldrev, newrev, ref, committer_email)

    Event.create(
      :project => self,
      :action => Event::Pushed,
      :data => data,
      :author_id => data[:user_id]
    )
  end

  def web_hook_data(oldrev, newrev, ref, committer_email)
    committer = User.find_by_email(committer_email)
    data = {
      before: oldrev,
      after: newrev,
      ref: ref,
      user_id: committer.id,
      user_name: committer_email,
      repository: {
        name: name,
        url: "git@#{GIT_HOST["host"]}:#{self.path}.git",
        description: description,
        homepage: "git@#{GIT_HOST["host"]}:#{self.path}.git",
      },
      commits: []
    }

    commits_between(oldrev, newrev).each do |commit|
      data[:commits] << {
        id: commit.id,
        message: commit.safe_message,
        timestamp: commit.date.xmlschema,
        url: "http://#{GIT_HOST['host']}/projects/#{project.id}/commits/#{commit.id}",
        author: {
          name: commit.author_name,
          email: commit.author_email
        }
      }
    end

    data
  end

  def commit(commit_id = nil)
    Commit.find_or_first(repo, commit_id)
  end

  def fresh_commits(n = 10)
    Commit.fresh_commits(repo, n)
  end

  def commits_with_refs(n = 20)
    Commit.commits_with_refs(repo, n)
  end

  def commits_since(date)
    Commit.commits_since(repo, date)
  end

  def commits(ref, path = nil, limit = nil, offset = nil)
    Commit.commits(repo, ref, path, limit, offset)
  end

  def commits_between(from, to)
    Commit.commits_between(repo, from, to)
  end

  def latest_event
    self.events.first || nil
  end

  def latest_event_date
    if latest_event
      latest_event.created_at.stamp("Sep 21, 2012")
    else
      nil
    end
  end

  private
  def update_path
    self.path = self.name.gsub(/\s+/,"_").downcase
  end

  def path_to_repo
    File.join(GIT_HOST["base_path"], "#{path}.git")
  end

  def repo
    @repo ||= Grit::Repo.new(path_to_repo)
  end

  def event_create
    Event.create(
      :project => self,
      :action => Event::Created,
      :author_id => current_user_id
    )
  end

  def event_update
    Event.create(
      :project => self,
      :action => Event::Updated,
      :author_id => current_user_id
    )
  end

  def set_owner_as_master
    self.user_projects.create(
      :project_access => UserProject::MASTER,
      :user => self.owner
    )
  end
end
