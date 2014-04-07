class User
  include Mongoid::Document
  rolify

  include Mongoid::Attributes::Dynamic

  has_many :markets, class_name: "Market", dependent: :delete, inverse_of: :user
  has_and_belongs_to_many :favorites, class_name: "Market", inverse_of: :favorited

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  has_many :authorizations

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time
  def like(market)
    favorites << market
  end

  def unlike(market)
    favorites.delete(market)
  end

  def can_like market
    does_not_own(market) && does_not_have_as_favorite(market)
  end

  def can_unlike market
    has_as_favorite market
  end

  def does_not_own(market)
    self != market.user
  end

  def does_not_have_as_favorite(market)
    !has_as_favorite(market)
  end

  def has_as_favorite market
    favorites.include?(market)
  end

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where({:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret}).first_or_initialize
    if authorization.user.blank?
      user = current_user.nil? ? User.where({:email => auth["info"]["email"]}).first : current_user
      user = create_with auth.info.email if user.blank?
      authorization.username = auth.info.nickname
      authorization.user_id = user.id
      authorization.save
    end
    authorization.user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def allowed_market_creation?
    market = self.markets.last
    market.nil? || market.created_one_month_ago?
  end

  private

  def self.create_with email
    user = User.new
    user.password = Devise.friendly_token[0,20]
    user.email = email
    user.save!
    user
  end

end
