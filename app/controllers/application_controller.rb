class ApplicationController < ActionController::Base
  private
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end
  helper_method :current_user

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def authenticate_user!
    unless user_signed_in?
      flash[:warning] = "You must sign in or sign up first!"
      redirect_to new_session_path
    end
  end

  def delete_danger
    flash.delete(:danger)
  end
end