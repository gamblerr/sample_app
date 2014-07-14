class Micropost < ActiveRecord::Base
  attr_accessible :content, :in_reply_to_id
  belongs_to :user
 # belongs_to :to, class_name: "User"
  has_many :replies, class_name: "Micropost", foreign_key: "in_reply_to_id"

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  default_scope order: 'microposts.created_at DESC'

  scope :not_replies, where(:in_reply_to_id => nil)

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

end