class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :retweet, class_name: :Micropost
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
end
