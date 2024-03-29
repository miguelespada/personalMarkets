class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps::Created

  include Tire::Model::Search
  include Tire::Model::Callbacks
  include UserElasticsearch


  after_create :set_default_role

  rolify


  has_many :markets, class_name: "Market", dependent: :destroy, inverse_of: :user
  has_and_belongs_to_many :favorites, class_name: "Market", inverse_of: :favorited
  has_many :coupon_transactions, class_name: "CouponTransaction", dependent: :destroy, inverse_of: :user
  has_many :wishes, class_name: "Wish", dependent: :destroy, inverse_of: :user
  has_many :bargains, class_name: "Bargain", dependent: :destroy, inverse_of: :user


  field :nickname, type: String
  field :description, type: String
  field :photos, type: Array

  has_and_belongs_to_many :following, class_name: 'User', inverse_of: :followers, autosave: true
  has_and_belongs_to_many :followers, class_name: 'User', inverse_of: :following


  has_one :featured, class_name: "Photo", as: :photographic, autobuild: true, dependent: :destroy
  accepts_nested_attributes_for :featured

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

  field :image, type: String

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
  

  #### elastic search

  def to_indexed_json
      { id: id,
        nickname: nickname,
        description: description
      }.to_json
  end

  def self.search(params, page = 1, per_page = 6)
    index_all
    return {:users => [], :total => 0} if User.count == 0 

    query = params[:user_query].blank? ? '*' : params[:user_query].gsub(/[\!]/, '')
    page ||= 1
    page = 1 if page < 1
    
    elasticQuery = lambda do |boolean|
      boolean.must {string query, default_operator: "AND"}
    end

    search = Tire.search 'users' do
      query do
        boolean &elasticQuery
      end

      search_size = per_page
      from (page - 1) * search_size
      size search_size
    end

    results = search.results
    {:users => results.collect{|result| find_by(id: result.to_hash[:id])}, :total => results.total}
  end

  #####

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

  def is_premium?
    role.include? "premium"
  end

  def role_names
    self.roles.map(&:name)
  end

  def add_market market_params
    market = self.markets.new market_params
    market.pro = self.is_premium?
    market
  end

  def create_new_vim_market 
    market = self.markets.new(:name => I18n.t(:new_vim_market))
    market.pro = self.is_premium?
    market
  end

  def owns object
    object.user_id == self.id
  end

  def name
    nickname || "Anonymous"
  end

  #### favorite market 

  def like(market)
    favorites << market
  end

  def unlike(market)
    favorites.delete(market)
  end

  def favorited?(market)
    favorites.include?(market)
  end 
  

  #### follow users  

  def follow(user)
    self.following << user
  end

  def unfollow(user)
    self.following.delete(user)
  end

  def following?(user)
    following.include?(user)
  end 



  #####

  def does_not_own(market)
    self != market.user
  end

  def can_see_markets_stats?
    has_role?(:premium) || has_role?(:admin)
  end

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where({:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret}).first_or_initialize
    if authorization.user.blank?
      user = current_user.nil? ? User.where({:email => auth["info"]["email"]}).first : current_user
      user = create_with auth.info.email if user.blank?
      user.update_image auth.info.image
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
    return true if self.has_role?("admin") 
    return true if number_of_last_month_markets < allowed_markets && self.number_of_drafts < 5
    false
  end

  def number_of_last_month_markets
    n = 0
    markets.each do |market|
      n = n + 1 if market.published_last_month? 
    end
    n
  end

  def days_until_can_create_new_market
    recent = most_recent_market(allowed_markets)
    return 0 if recent == nil
    30 - (Date.today - recent.publish_date).to_i
  end

  def most_recent_market n
    markets.select{|m| m.has_been_published?}.sort_by{|m| m[:publish_date]}[-n]
  end

  def admin?
    has_role?("admin")
  end

  def update_image image
    self.image = image
    self.save!
  end

  def remaining_markets
    allowed_markets - number_of_last_month_markets
  end

  def self.icon
    "fa-users"
  end

  def number_of_drafts
    return self.markets.count{|m| !m.has_been_published?}
  end

  def too_many_wishes?
    return self.wishes.count >= 10
  end

  def too_many_bargains?
    return self.bargains.count >= 10
  end

  def profile_completed?
    return !self.nickname.blank? && !self.featured.blank? && !self.description.blank?
  end

  def user
    self
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

  def allowed_markets
    return 4 if self.has_role?("premium")
    return 1000000 if self.has_role?("admin")
    1
  end


end
