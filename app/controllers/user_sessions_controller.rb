class UserSessionsController < ApplicationController
  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new
    #render :layout => "links"
  end
  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.remember_me = true
    if @user_session.save
      @current_user = @user_session
      flash[:notice] = 'Successfully loggedin.'
      redirect_to_root
    else
      render :action => "new"
    end
  end
  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to root_url
  end

  def redirect_to_root
    redirect_to :controller => "links", :action => "index"
  end

end
