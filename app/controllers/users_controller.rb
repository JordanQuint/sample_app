class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  before_filter :send_home_if_signed_in, :only => [:new, :create]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      #Save successful
    else
      @user.password = ""              #this resets the password so it has to be
      @user.password_confirmation = "" # entered again upon a failed signup
      @title = "Sign up"
      render 'new'
    end
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    
    # if params[:admin] == 1
    #       @user.toggle!(:admin)
    #     end
    
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    deleted_user = User.find(params[:id]).destroy
    flash[:success] = "#{deleted_user.name} destroyed."
    redirect_to users_path
  end
  
  private
    
    def admin_user
      redirect_to(root_path) unless current_user.admin? &&
                                    User.find(params[:id]) != current_user
    end
    
    def send_home_if_signed_in
      redirect_to(root_path) if signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end
end
