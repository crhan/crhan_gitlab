module ProjectsHelper
  def owner_email(p)
    if p.owner.try(:email)
      p.owner.email
    else
      "nil"
    end
  end

  def default_owner(project)
    if project.owner.nil?
      current_user.id
    else
      project.owner.id
    end
  end

  # Only Owner or admin could change project's owner
  def disable_edit_owner?(project)
    !(current_user.admin or current_user == project.owner)
  end

  def project_clone_path project
    "git@#{GIT_HOST["host"]}:#{project.path}.git"
  end
end
