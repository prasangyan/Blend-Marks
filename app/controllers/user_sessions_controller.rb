class UserSessionsController < ApplicationController
                      before_filter "setsubdomainasgroup"

  # for login  request
  def new
    @user_session = UserSession.new
    #render :layout => "links"
  end

  # for logout
  def destroy
    @user_session = UserSession.find
    unless @user_session.nil?
      @user_session.destroy
    end
    new
    render :new
  end

  # for login  post
  def create
    unless params[:user_session].nil?
      @user_session = UserSession.new(params[:user_session])
      @user_session.remember_me = true
      if @user_session.save
        @current_user = @user_session
        flash[:notice] = 'Successfully logged in.'
        redirect_to_root
      else
        flash[:notice] = "invalid parameters passed."
        render :action => "new"
      end
    else
        flash[:notice] = "user credentials not found."
        new
        render :action => "new"
    end
  end


  private                      
  def redirect_to_root
    redirect_to :controller => "links", :action => "index"
  end

end
