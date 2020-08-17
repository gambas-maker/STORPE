class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    # email_with_name = %("#{@user.pseudo}" <#{@user.email}>)
    mail(to: @user, subject: 'Bienvenue chez STORPE ⚽ 🏀!')
  end
end
