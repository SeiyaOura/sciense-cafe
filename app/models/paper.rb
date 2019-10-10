class Paper < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 1023}
  validates :author, presence: true, length: { maximum: 4095}
  validates :bibliography, presence: true, length: { maximum: 1023}
  validates :link, length: { maximum: 1023}
  validates :comment, length: { maximum: 1048575}
  
  has_many :favorites, dependent: :destroy
  
  private
  
  #Ransack用 (検索機能はransackで実装しようとしていたが自作に変更)
  #検索対象はtitle author bibliography commentのみ
  def self.ransackable_attributes(auth_object = nil)
    %w(title author bibliography comment)
  end
  # 並べ替え対象はcreated atのみ
  def self.ransortable_attributes(auth_object = nil)
    %w(created_at)
  end
  
  # 自作の検索関数 title authoe bibliograpy commentが検索対象
  # 検索対象を1つのカラムにしたい場合はcolmunとして引数をとればできそう
  def self.search(keyword, sort)
    if keyword == nil
      ps = Paper.all
    else
      ps = Paper.where(['title LIKE ? OR author LIKE ? OR bibliography LIKE ? OR comment LIKE?', "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"])
    end
    
    case sort
    when "Most Recent" then
      return ps.order("id DESC")
    when "Most Popular" then
      hs = ps.map {|p|                                           
       [p.id, p.favorites.count]
      }.sort{|a,b| b[1]<=>a[1]}.to_h
      return Paper.find(hs.keys)
    when "Most Discussed" then
      hs = ps.map {|p|                                           
       [p.id, p.reviews.count]
      }.sort{|a,b| b[1]<=>a[1]}.to_h
      return Paper.find(hs.keys)
    else
      #Most Recentで返す
      return ps.order("id DESC")
    end
    
  end
  
  has_many :reviews
  
end
