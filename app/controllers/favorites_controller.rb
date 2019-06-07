class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    paper = Paper.find(params[:paper_id])
    current_user.like(paper)
    flash[:success] = 'ポストをお気に入りしました。'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    paper = Paper.find(params[:micropost_id])
    current_user.unlike(paper)
    flash[:success] = 'ポストのお気に入りを解除しました。'
    redirect_back(fallback_location: root_path)
  end
end