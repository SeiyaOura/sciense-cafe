class Review < ApplicationRecord
  belongs_to :user
  belongs_to :paper
  
  validates :comment, presence: true, length: { maximum: 1048575 }
end
