# == Schema Information
#
# Table name: user_profiles
#
#  id                     :integer         not null, primary key
#  login                  :string(255)
#  password_hash          :string(255)
#  password_salt          :string(255)
#  password_reset_token   :string(255)
#  auth_token             :string(255)
#  password_reset_sent_at :datetime
#  user_type              :string(255)
#  user_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  branch_id              :integer
#

class UserProfile < ActiveRecord::Base
  belongs_to :user, :polymorphic => true
  validates_presence_of :user

  belongs_to :branch
  validates_presence_of :branch
  
  has_many :role_memberships, :dependent => true, :dependent => :destroy
  has_many :roles, :through => :role_memberships	  
  
  attr_accessor :password
  attr_accessible :login, :password, :password_confirmation, :user, :branch, :branch_id
  before_save :encrypt_password
  before_create { generate_token(:auth_token) }

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_length_of :password, :minimum => 3, :maximum => 50
  validates_presence_of :login
  validates_uniqueness_of :login
  
  def authenticate(password)	
    if self.password_hash == BCrypt::Engine.hash_secret(password, self.password_salt)
      self
    else
      nil
    end
  end

  def encrypt_password
   if password.present?
     self.password_salt = BCrypt::Engine.generate_salt
     self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
   end
  end	

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    CampusMailer.password_reset(self).deliver
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.base64
    end while UserProfile.exists?(column => self[column])
  end
  
  def has_this_role?(role_id)
    !RoleMembership.for_role(role_id).for_user_profile(self.id).all.empty?
  end
			  
end
