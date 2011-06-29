require 'rubygems'
require 'net/http'
require 'uri'

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

  def rescue_action_locally(exception)
    rescue_action_in_public(exception)
    super
  end

  def rescue_action_in_public(exception)
    # all exception handling here
    begin
      if(ENV['RAILS_ENV'].to_s != "development")
        error = Error.new
        error.title = exception.message
        error.fulltrace = exception.backtrace.join("\r\n")
        if error.save  # to avoid creating of repeated bug in pivotal tracker, unless dump of errors may exists in pivotal tracker
          # upload this bug to pivotal tracker
          projectid = "241805"
          key = "1155359c5df5c25fa1c81e0de22e22c2"
          errorTitle = exception.message
          errorDescription = exception.backtrace.join("\r\n")
          resource_uri = URI.parse("http://www.pivotaltracker.com/services/v3/projects/#{projectid}/stories")
          headers = {'Content-Type' => 'application/xml', 'X-TrackerToken' => key }
          data = "<story><story_type>bug</story_type><name>#{errorTitle}</name><description>#{errorDescription}</description></story>"
          @response = Net::HTTP.start(resource_uri.host,resource_uri.port) { |http|
            http.post(resource_uri.path,data,headers)
          }
        end
      end
    rescue
    end
    render :template => "error/index"
  end

end
