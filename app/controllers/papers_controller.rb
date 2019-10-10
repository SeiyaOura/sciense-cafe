class PapersController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit, :update]
  
  def index
    case params[:sort]
    when "Most Recent" then
      @papers = Paper.search(params[:keyword], params[:sort]).page(params[:page]).per(25)
      @keyword = params[:keyword]
      @sort = params[:sort]
    when "Most Popular", "Most Discussed" then
      @papers = Kaminari.paginate_array(Paper.search(params[:keyword], params[:sort])).page(params[:page]).per(25)
      @keyword = params[:keyword]
      @sort = params[:sort]
    else
      #Most Recent
      @papers = Paper.search(params[:keyword], params[:sort]).page(params[:page]).per(25)
      @keyword = params[:keyword]
      @sort = params[:sort]
    end
 end
  
  def show
    @paper = Paper.find(params[:id])
    @reviews = @paper.reviews.order(id: :desc).page(params[:page]).per(25)
  end
  
  def new
     @paper = Paper.new
  end

  def create
    @paper = current_user.papers.build(paper_params)
    
    if @paper.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to @paper.user
    else
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render :new
    end
  end

  def edit
    @paper = Paper.find(params[:id])
  end

  def update
    @paper = Paper.find(params[:id])

    if @paper.update(paper_params)
      flash[:success] = '正常に更新されました'
      redirect_to @paper
    else
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end
  end

  def destroy
    @paper.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_to @paper.user
  end
  private

  def paper_params
    params.require(:paper).permit(:title, :author, :bibliography, :link, :comment, :image)
  end
  
  def correct_user
    @paper = current_user.papers.find_by(id: params[:id])
    unless @paper
      redirect_to @paper.user
    end
  end
  
end
