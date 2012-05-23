class PostReceive
  @queue = :post_receive

  def self.perform(reponame, oldrev, newrev, ref, committer_email)
    project = Project.find_by_path(reponame)
    return false if project.nil?

    # Ignore push from non-gitlab users
    return false unless User.find_by_email(committer_email)

    # Create push event
    project.observe_push(oldrev, newrev, ref, committer_email)

  end
end

