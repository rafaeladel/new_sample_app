class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user?, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  # Signing up
  def create
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      # remember @user
      @user.send_activation
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'users/new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    if @user.save
      flash[:success] = "Profile edited."
      redirect_to @user
    else
      render 'users/edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
    def user_params

      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user?
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

    def admin_user
      redirect_to users_url unless current_user.admin?
    end
end
