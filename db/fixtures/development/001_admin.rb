unless User.count > 0
  admin = User.create(
    :email => "crhan123@gmail.com",
    :password => "123123",
    :password_confirmation => "123123"
  )

  admin.admin = true
  admin.save!

  if admin.valid?
    puts %q[
    Administrator account created:

    login.........crhan123@gmail.com
    password......123123
    ]
  end
end
