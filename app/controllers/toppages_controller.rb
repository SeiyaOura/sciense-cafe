class ToppagesController < ApplicationController
  def index
    if logged_in?
      @papers = current_user.feed_papers.order(id: :desc).page(params[:page])
    end
  end
end
