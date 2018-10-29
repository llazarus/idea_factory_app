class SessionsController < ApplicationController
  def new
    delete_danger
  end

  def create
    delete_danger
    user = User.find_by_email params[:email]

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Sign in successful!"
      redirect_to root_path
    else
      flash.now[:danger] = "Wrong credentials!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Sign out successful!"
    redirect_to root_path
  end
end