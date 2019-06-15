class Paper < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 1023}
  validates :author, presence: true, length: { maximum: 4095}
  validates :bibliography, presence: true, length: { maximum: 1023}
  validates :link, length: { maximum: 1023}
  validates :comment, length: { maximum: 1048575}
  
  has_many :favorites, dependent: :destroy
  
  private
  
  #ransacker定義したいがよくわからない(質問する)
  ransacker :comment_length
  
  #Ransack
  # 検索対象はtitle author bibliography commentのみ
  def self.ransackable_attributes(auth_object = nil)
    %w(title author bibliography comment)
  end
  # 並べ替え対象はcreated atのみ
  def self.ransortable_attributes(auth_object = nil)
    %w(created_at comment_length)
  end
  
  has_many :reviews
  
end
