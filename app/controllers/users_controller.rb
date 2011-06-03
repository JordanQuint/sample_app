class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @title = @user.name
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

end
