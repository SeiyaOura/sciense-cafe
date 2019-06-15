class ReviewsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @paper = Paper.find(params[:paper_id])
    @review = @paper.reviews.build(review_params)
    @review.user_id = current_user.id
    if @review.save
      flash[:success] = 'コメントを投稿しました。'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:danger] = 'コメントの投稿に失敗しました。'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    flash[:success] = 'コメントを削除しました。'
    redirect_back(fallback_location: root_path)
  end

 private

  def review_params
    params.require(:review).permit(:comment)
  end

  def correct_user
    @review = current_user.reviews.find_by(id: params[:id])
    unless @review
      redirect_to root_url
    end
  end
  
end
