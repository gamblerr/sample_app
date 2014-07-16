class Micropost < ActiveRecord::Base
  attr_accessible :content, :in_reply_to_id, :posted_to_id 
  searchkick
  belongs_to :user
 # belongs_to :to, class_name: "User"
  has_many :replies, class_name: "Micropost", foreign_key: "in_reply_to_id"
  has_many :posttousers
  has_many :posting_to_users, through: :posttousers, source: :user
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
  def self.from_users_followed_by_including_incomingposts(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    joins("LEFT OUTER JOIN posttousers ON microposts.id = posttousers.micropost_id").where("microposts.user_id IN (#{followed_user_ids}) OR microposts.user_id = :user_id OR posttousers.user_id = :user_id",
          user_id: user.id)
  end
def micropost_extract()
  users = []
  tags = []
  contents = self.content.split(' ')
  contents.each do |content|
    if (content.split('').first =='@')
        users << content[1..-1]
      end
    end
    contents.each do |content|
    if (content.split('').first =='#')
        tags << content[1..-1]
      end
    end
    ids = User.where(:username => users).pluck(:id)
    ids.each do |userid|
      Posttouser.create(:user_id => userid, :micropost_id => self.id )
    end
    tags.each do |tag|
      Tag.create(:tag_name => tag, :micropost_id => self.id)
    end
end



 # def isuser(username)
#   User.where("username = ?",username).first.try(:id)
# end


end