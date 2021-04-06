class FriendsController < ApplicationController
  def index
    @user = current_user
    @friends = @user.friends
    @requests = @user.requested_friends
    @pending = @user.pending_friends
    @championship = Championship.all
  end

  def create
    @user = current_user
    friend = User.find_by(id: params[:id])
    @user.friend_request(friend)

    redirect_to friends_path
  end

    def add
      @user = current_user
      friend = User.find_by(id: params[:id])
      @user.accept_request(friend)

      redirect_to friends_path
    end

    def reject
      @user = current_user
      friend = User.find_by(id: params[:id])
      @user.decline_request(friend)

      redirect_to friends_path
    end

    def remove
      @user = current_user
      friend = User.find_by(id: params[:id])
      @user.remove_friend(friend)

      redirect_to user_path(friend)
    end

  def search
    @search = params[:search]
    @results = []
    User.where(pseudo: @search).find_each do |user|
      @results << user
    end

    # @results = User.where("users.pseudo like ?", "#%{@search}%")
    # @user =
    # @results = User.where(pseudo: @search)
    # @results = User.all.select do |user|
    #   user.pseudo.downcase.include?(@search)
    # end
  end
end
