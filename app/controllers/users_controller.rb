class UsersController < ApplicationController
  def create
    @user = User.last
    if @user.exists?
      UserMailer.welcome_email(@user).deliver_now
    end
  end
end
