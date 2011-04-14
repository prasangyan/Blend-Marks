class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  helper_method :current_user
  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  def current_user
    return @current_user if defined? (@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  def isuserloggedin
    if current_user.nil?
      redirect_to login_url
    end
    if session[:id].nil?
      session[:id] = params[:id]
    end
  end
  def setsubdomainasgroup
    group = Group.find(:all, :conditions => "title = '#{request.subdomain}'")
    if group.count == 0
      session[:group] = nil
      redirect_to error_url
    else
      session[:group] = group[0].id
    end
  end
end
