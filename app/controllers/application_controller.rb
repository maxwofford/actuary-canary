class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  protected

  def authenticate_user!
    controller = params[:controller]
    action = params[:action]
    token = params[:token]

    unless user_signed_in?
      login_from_token unless token.blank?
      unless controller == "pages" and action == "home"
        redirect_to "/", notice: "Invalid magic link"
      end
    end
  end

  def login_from_token
    token = params[:token]

    if (user = User.find_by_token token)

      Rails.logger.info("One time login token used for user #{user.id}")
      sign_in user
      user.new_token!

    else

      Rails.logger.info("No user found from token: '#{token}'")

    end
  end
end
