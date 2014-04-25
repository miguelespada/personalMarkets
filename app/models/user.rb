class User
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Attributes::Dynamic

  after_create :set_default_role

  rolify

  has_many :markets, class_name: "Market", dependent: :delete, inverse_of: :user
  has_and_belongs_to_many :favorites, class_name: "Market", inverse_of: :favorited
  has_many :coupon_transactions, class_name: "CouponTransaction", dependent: :delete, inverse_of: :user
  has_many :wishes, class_name: "Wish", dependent: :delete, inverse_of: :user

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

  field :status, :type => String, :default => "active"

  has_many :authorizations
  slug :email, history: false


  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  def available_statuses
    ["active", "inactive"] - [self.status]
  end

  def available_roles
    Roles.all - [self.role]
  end

  def active_for_authentication?
    super && self.active?
  end

  def inactive_message
    self.active? ? super : :inactive
  end

  def active?
    self.status != "inactive"
  end

  def update_status new_status
    self.status = new_status
    self.save!
  end

  def update_role new_role
    self.remove_role self.role
    self.add_role new_role.to_sym
  end

  def role
    return "" if self.roles.empty?
    self.role_names.join(", ")
  end

  def role_names
    self.roles.map(&:name)
  end

  def add_market market_params
    self.markets.new market_params
  end

  def owns object
    object.user_id == self.id
  end

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
    market.nil? || market.created_one_month_ago? || self.has_role? "admin"
  end

  private

  def self.create_with email
    user = User.new
    user.password = Devise.friendly_token[0,20]
    user.email = email
    user.save!
    user
  end

  def set_default_role
    add_role :normal if self.roles.blank?
  end

end
