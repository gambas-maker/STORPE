class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :player_seasons
  has_many :forecasts, through: :player_seasons
  validates :email, 'valid_email_2/email': { mx: true }

  after_commit :async_update
  validates_uniqueness_of :pseudo

  private

  def async_update
    ChampionshipJob.perform_now(self.id)
    @user = User.last
    1.time { UserMailer.welcome_email(@user).deliver_now }
  end
end
