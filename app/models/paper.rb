class Paper < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 1023}
  validates :author, presence: true, length: { maximum: 4095}
  validates :bibliography, presence: true, length: { maximum: 1023}
  validates :link, length: { maximum: 1023}
  validates :comment, length: { maximum: 1048575}
  
  has_many :favorites, dependent: :destroy
end
