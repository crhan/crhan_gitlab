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
    if t.user.email == t.project.owner.try(:email)
      true
    else
      false
    end
  end

  def show_access(access)
    case access
    when 10   then "Reader"
    when 20   then "Writer"
    when 30   then "Master"
    end
  end

end
