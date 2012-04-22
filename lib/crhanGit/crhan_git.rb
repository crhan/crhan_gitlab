require 'grit'
require 'gitolite'

module CrhanGit
  class CrhanGit
    def initialize
      pull

      # new gitolite object
      @ga_repo = Gitolite::GitoliteAdmin.new("#{@local_dir}/gitolite-admin")
      @conf = @ga_repo.config
    end

    def update_repo project
      repo_name = project.path
      repo = if @conf.has_repo?(repo_name)
               @conf.get_repo(repo_name)
             else
               Gitolite::Config::Repo.new(repo_name)
             end

      reader = project.repo_reader
      writer = project.repo_writer
      master = project.repo_master

      repo.clean_permissions
      repo.add_permission("R", "", reader.email) unless reader.blank?
      repo.add_permission("RW", "", writer.email) unless writer.blank?
      repo.add_permission("RW+", "", master.email) unless master.blank?

      @conf.add_repo(repo, true)
      @ga_repo.save_and_apply
    end

    def pull
      # check out gitolite-admin
      @local_dir = File.join(Dir.tmpdir, "crhanGit-#{Time.now.to_i}")
      Dir.mkdir @local_dir
      `git clone #{GIT_HOST["admin_uri"]} #{@local_dir}/gitolite-admin`
    end

    def add_key key
      new_key = Gitolite::SSHKey.from_string(key.key, key.user.email, key.identifier)
      @ga_repo.add_key(new_key)
      @ga_repo.save_and_apply
    end

    def del_key key
      del_key = Gitolite::SSHKey.from_string(key.key, key.user.email, key.identifier)
      @ga_repo.rm_key(del_key)
      @ga_repo.save_and_apply
    end

    def del_repo repo
      del_repo = @conf.get_repo(repo.name)
      @conf.rm_repo(del_repo)
      @ga_repo.save_and_apply
    end

  end
end
