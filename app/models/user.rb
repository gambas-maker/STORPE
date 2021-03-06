class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  has_many :player_seasons
  has_many :forecasts, through: :player_seasons
  validates :email, 'valid_email_2/email': { mx: true }
  validates :pseudo, presence: true, length: {maximum: 12}
  after_commit :async_update
  validates_uniqueness_of :pseudo
  has_friendship
  include AlgoliaSearch

  algoliasearch do
    attributes :name, :pseudo
  end

  after_create :mailer

  def friends?
    self.friends
  end

  def friend_requests?
    self.requested_friends.any?
  end

  def requested_friends?
    self.pending_friends.any?
  end

  def invite_friend(user)
    self.friend_request(user)
  end

  # def not_friends
  #   potential = []
  #   User.all.each do |user|
  #     if(self.friends_with?(user) != true && self != user && self.friends.include?(user) != true && self.pending_friends.include?(user) != true && self.requested_friends.include?(user) != true)
  #       potential << user
  #     end
  #   end
  #   potential
  # end

  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = data["email"] if user.email.blank?
  #     end
  #   end
  # end

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0,20]
  #     user.name = auth.info.name   # assuming the user model has a name
  #   end
  # end

  private

  def async_update
    ChampionshipJob.perform_now(self.id)
  end

  def mailer
    MailmarketJob.set(wait: 2.days).perform_later(self.id)
  end
end
