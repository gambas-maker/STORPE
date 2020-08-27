class UserMailer < ApplicationMailer
  def welcome_email
    # @user = user
    mail(to: "clement.guibaud@storpe.com", subject: "Bienvenue chez STORPE  ⚽ 🏀!")
  end
end
