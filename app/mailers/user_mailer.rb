class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Bienvenue chez STORPE ⚽ 🏀!')
  end
end
