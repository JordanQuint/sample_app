class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      flash[:success] = "Sign-in successful. Welcome back, #{user.name}!"
      redirect_to user
      #sign the user in and redirect to the user's show page
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
