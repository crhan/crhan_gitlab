module ProjectsHelper
  def owner_email(p)
    if p.owner.try(:email)
      p.owner.email
    else
      "nil"
    end
  end
end
