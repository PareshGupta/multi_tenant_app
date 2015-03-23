class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_filter :handle_subdomain

  def after_sign_in_path_for(resource)
    articles_path
  end

  def handle_subdomain
    if @user = User.find_by_subdomain(request.subdomain)
      PgTools.set_search_path @user.subdomain
    else
      PgTools.restore_default_search_path
    end
  end

end
