module ApplicationHelper
  def owner_email(p)
    if p.owner.nil?
      "nil"
    else
      p.owner.email
    end
  end

  def is_owner?(a_user_project)
    t = a_user_project
    if t.user.email == t.project.owner.email
      true
    else
      false
    end
  end

end
