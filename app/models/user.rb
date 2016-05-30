class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  # validates :password, length: { minimum: 4 }

  has_many :microposts
  has_many :following_relationships, class_name: "Relationship",
                                      foreign_key: "follower_id",
                                      dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed

  has_many :follower_relationships, class_name: "Relationship",
                                      foreign_key: "followed_id",
                                      dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower

  has_many :likes, dependent: :destroy
  has_many :like_microposts, through: :likes, source: :micropost


  # 他のユーザをフォロする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォロしているユーザをアンフォロする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザをフォロしているかどうか
  def following?(other_user)
    following_users.include?(other_user)
  end

  def like(micropost)
    likes.find_or_create_by(micropost_id: micropost.id)
  end

  def unlike(micropost)
    likes.find_by(micropost_id: micropost.id).destroy
  end

  def like?(micropost)
    likes.find_by(micropost_id: micropost.id)
  end

  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end

end
