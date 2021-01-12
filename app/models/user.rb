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

  after_create :mailer

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
