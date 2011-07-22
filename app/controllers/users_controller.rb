class UsersController < ApplicationController
  before_filter "setsubdomainasgroup"
  before_filter "isuserloggedin", :only =>["edit", "update","destroy", "invitepeople", "confirminvitation"]

  def new
    @user = User.new
  end

  def create
    unless params[:user].nil?
      @user = User.new(params[:user])
      @user.username = @user.email
      @user.isnotificationsubscribed = true
      @user.group_id = session[:group]
      @user.bookmarkletcode = User.random_string(10)
      if @user.save
        flash[:notice] = 'Registration successfully completed.'
        redirect_to :controller => "links", :action => "index"
      else
        flash[:notice] = "Invalid parameter values passed."
        #puts @user.errors.full_messages
        render :action => "new"
      end
    else
      flash[:notice] = 'user credentials not passed.'
      render :action => "new"
    end
  end

  def edit
    @user = current_user
  end

  def update
    unless params[:user].nil?
      @user = current_user
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your profile updated successfully.'
        redirect_to :controller => "links", :action => "index"
      else
        #puts @user.errors.full_messages
        flash[:notice] = 'Invalid parameters passed.'
        render :action => "edit"
      end
    else
      flash[:notice] = 'User credentials not passed.'
      edit
      render :edit
    end
  end

  def forgotpassword
    unless params[:username].nil?
      user = User.find_by_username(params[:username].to_s)
      unless user.nil?
        @error = nil
        user.send_reset_password
        @status = "An email has been sent to you for resetting your password."
        render :success
      else
        @error = 'Invalid email address entered!'
      end
    end
  end

  def success
    @status = ""
  end

  def resetpassword
    unless params[:id].nil?
      @user = User.where(:reset_code => params[:id]).first
      if @user.nil?
        redirect_to :controller => "error", :action => "index"
      end
    else
      redirect_to :controller => "error", :action => "index"
    end
  end

  def setpassword
    unless params[:username].nil?
      unless params[:password].nil?
        unless params[:confirm_password].nil?
          unless params[:password].to_s != params[:confirm_password]
            @user = User.find_by_username(params[:username])
            @user.password = params[:password]
            @user.password_confirmation = params[:password]
            if @user.save
              @status = "Your password has been modified."
            else
              @status = "Oops! We are unable to set your password."
            end
            render :success
            return
          end
        end
      end
      @user = User.find_by_username(params[:username])
      render :resetpassword
    else
      redirect_to :controller => "error", :action => "index"
    end
  end

  def destroy
    unless params[:id].nil?
      @user = User.find_by_id(params[:id])
      unless @user.nil?
        @user.destroy
      end
      redirect_to :controller => "links", :action => "index"
    else
      redirect_to error_url
    end
  end

  def invitepeople
     @user = User.new
     render :layouts=> false
  end

  def confirminvitation
    unless params[:email].nil?
      email = params[:email]
      email.split("\n").each do |mail|
        mail.split(";").each do |m|
          user = User.new
          user.group_id = session[:group]
          user.bookmarkletcode = User.random_string(10)
          user.email = m
          password = User.random_string(10)
          user.password = password
          user.password_confirmation = password
          user.username =   m
          user.isnotificationsubscribed=true
          if user.save
            user.send_invitation
          else
            puts "error at saving user due to " + user.errors.full_messages[0]
          end 
        end
      end
      render :text => "success"
    else
      render :text => "invalid parameters passed."
    end
  end

end
