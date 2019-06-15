class UsersController < ApplicationController
    before_action :require_user_logged_in, only: [:index, :show, :edit, :destroy, :followings, :followers, :likes]
    
  def index
    @search = User.ransack(params[:q])
    3.times { |i| @search.build_condition unless @search.conditions[i] }
    @search.build_sort if @search.sorts.empty?
    @users = @search.result.page(params[:page]).per(25)
  end
  
  def show
    @user = User.find(params[:id])
    @papers = @user.papers.order(id: :desc).page(params[:page]).per(25)
    counts(@user)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = '正常に更新されました'
      redirect_to @user
    else
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:success] = '正常に退会しました'
    redirect_to root_url
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @likes = @user.likes.page(params[:page])
    counts(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile, :field, :position, :publication, :image)
  end
end
