class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :profile, presence: true, length: { maximum: 1023}
  validates :field, presence: true, length: { maximum: 255}
  validates :position, presence: true, length: { maximum: 255}
  validates :publication, presence: true, length: { maximum: 8191}
  has_secure_password
  mount_uploader :image, ImagesUploader
  
  has_many :papers
  
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_papers
    Paper.where(user_id: self.following_ids + [self.id])
  end
  
  has_many :favorites
  has_many :likes, through: :favorites, source: :paper

  def like(others_post)
    mine = false
    
    self.papers.each do |paper|
      if paper.id == others_post.id
        mine = true
      end
    end
    
    unless mine
      self.favorites.find_or_create_by(paper_id: others_post.id)
    end
  end
  
  def unfavorite(others_post)
    favorite = self.favorites.find_by(paper_id: others_post.id)
    favorite.destroy if favorite
  end
  
  def like?(others_post)
    self.likes.include?(others_post)
  end
  
end
