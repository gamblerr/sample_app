# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :name,:username, :email, :password, :password_confirmation
  has_secure_password
  searchkick word_start: [:name, :username]
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship",dependent: :destroy
  has_many :followers, through: :reverse_relationships
  has_many :posttousers
  has_many :incoming_microposts, through: :posttousers, source: :micropost
  #has_many :replies, class_name: "Micropost", foreign_key: "to_id"
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: {maximum: 50 }, uniqueness: {case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  def feed
    Micropost.where(:id => Micropost.from_users_followed_by(self).pluck(:id) + self.incoming_microposts.pluck(:id) )
   #Micropost.from_users_followed_by_including_incomingposts(self)
    
  end
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  

private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end