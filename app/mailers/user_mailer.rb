class UserMailer < ApplicationMailer
  default from: 'clement.guibaud@storpe.com'

  def welcome_email(user_id)
    @user = User.find(user_id)
    email_with_name = %("#{@user.pseudo}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Bienvenue chez STORPE ⚽ 🏀!')
  end
end
