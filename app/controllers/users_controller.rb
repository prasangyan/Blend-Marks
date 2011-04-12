class UsersController < ApplicationController
    # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
 end
  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.username = @user.email
    @user.isnotificationsubscribed = true
    if @user.save
      flash[:notice] = 'Registration successfully completed.'
      redirect_to root_url
    else
      puts @user.errors.full_messages
      render :action => "new"
    end
  end
  def edit
    @user = current_user
  end

 def forgotpassword
    unless params[:username].nil?
      user = User.find(:first, :conditions => "username = '#{params[:username]}'")
      unless user.nil?
        user.send_reset_password
        @status = "An email has been send to you for resetting your BlendMarks password."
        render :success
      else
          @error = 'Invalid email address entered!'
      end
    end
  end

  def success
  end

  def resetpassword
    @user = nil
    unless params[:id].nil?
      user = User.find(:first, :conditions => "reset_code = '#{params[:id]}'")
      unless user.nil?
        @user = user
      end
    end
  end

  def setpassword
    unless params[:password].nil? and params[:confirm_password].nil?
       unless params[:password].to_s != params[:confirm_password]
          @user = User.where(:username => params[:username]).limit(1)
          @user = @user[0]
          @user.password = params[:password]
          @user.password_confirmation =     params[:password]
          if @user.save
            @status = "Your password has been reseted successfully."
          else
            @status = "Oops! We are unable to set your password."
          end
          render :success
          return
       end
    end
    @user = User.where(:username => params[:username])
    render :resetpassword
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = current_user
      if @user.update_attributes(params[:user])
        redirect_to(@user, :notice => 'Your profile updated successfully.')
        redirect_to root_url
      else
        render :action => "edit"
      end
  end
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(users_url)
  end
end