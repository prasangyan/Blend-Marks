require 'test_helper'
require 'authlogic/test_case'

class LinksControllerTest < ActionController::TestCase
    include Authlogic::TestCase
    setup :activate_authlogic

  setup do

    @request.host = "test.local.host"

  end

  test "check Link controller actions without logged in" do

      # to log out if its logged in with another test controller
      @controller = UserSessionsController.new
      get :destroy

      # get back to the links controller
      @controller = LinksController.new

      # trying to get links home page without login
      get "index"
      assert_redirected_to login_url, "Links-Index action is not validated the user authentication"

      get "search"
      assert_redirected_to login_url, "Links-Search action is not validated the user authentication"

      get "tagfilter"
      assert_redirected_to login_url, "Links-tagfilter action is not validated the user authentication"

      get "sendnotification"
      assert_redirected_to login_url, "Links-sendnotification action is not validated the user authentication"

      get "new"
      assert_redirected_to login_url, "Links-new action is not validated the user authentication"

      get "edit"
      assert_redirected_to login_url, "Links-edit action is not validated the user authentication"

      get "create"
      assert_redirected_to login_url, "Links-create action is not validated the user authentication"

      get "addtag"
      assert_redirected_to login_url, "Links-addtag action is not validated the user authentication"

      get "update"
      assert_redirected_to login_url, "Links-update action is not validated the user authentication"

      get "destroy"
      assert_redirected_to login_url, "Links-destroy action is not validated the user authentication"

      get "readlinksfrommail"
      assert_redirected_to login_url, "Links-readlinksfrommail action is not validated the user authentication"

      get "tagautocomplete"
      assert_redirected_to login_url, "Links-tagautocomplete action is not validated the user authentication"

      #trying to access protected methods
      get "tagautocomplete"
      assert_response :redirect
      assert_redirected_to login_url

      set_login

      # posting the log in information 
      @controller = UserSessionsController.new
      post :create, :user_session => {:username => "santhosh@itxsolutionsindia.com", :password => "password@123"}
      assert_equal "Successfully logged in.",  flash[:notice].to_s
      assert_redirected_to :controller => "links", :action => "index"

      # come back to Links
      @controller = LinksController.new

      #checking the link index without :pageindex parameter
      get :index
      assert_response :success
      assert_equal flash[:filter], false
      assert assigns(@links), "Links not assigned for the index page"

      #puts assigns(@message)

      # checking the links with pagination parameters
      1.upto(10) do |idx|
        get :index , :pageindex =>idx
        assert_response :success
        assert_equal flash[:filter], false
        assert assigns(@links), "Links not assigned for the index page"
      end

      # checking the search action without passing criteria
      get :search
      assert_response :success
      assert assigns(@links), "Links not assigned for the index page"

      #checking the search action without pageindex
      get :index , :criteria => "some text here"
      assert_response :success
      assert assigns(@links), "Links not assigned for the index page"

      # checking the search action
      1.upto(10) do |idx|

        get :index , :criteria => "some text here", :pageindex =>idx
        assert_response :success
        assert assigns(@links), "Links not assigned for the index page"

      end

      # checking the tagfilter action without passing tag
      get :tagfilter
      assert_response :success
      assert assigns(@links), "Links not assigned for the index page"

      #checking the tagfiilter action without pageindex
      get :index , :tag => "unknown"
      assert_response :success
      assert assigns(@links), "Links not assigned for the index page"

      # checking the tagfilter action with page index
      1.upto(10) do |idx|

        get :tagfilter , :tag => "unknown", :pageindex =>idx
        assert_response :success
        assert assigns(@links), "Links not assigned for the index page"

      end

      # checking the sendnotification action
      get :sendnotification
      assert_response :success
      assert_equal @response.body, "success", "User notification is not sent."

      # checking the new action
      get :new
      assert_response :success
      assert assigns(@link), "The new action is not properly rendered."

      # checking the edit action without id
      get :edit
      assert_response :redirect
      assert_redirected_to error_url, "The edit action is malfunctioning without parameter."

      lnk  = Link.find_by_id(1)
      unless lnk.nil?
        lnk.destroy
      end
      # checking the edit action with wrong id
      get :edit, :id => 1
      assert_response :redirect
      assert_redirected_to error_url, "The edit action is malfunctioning with invalid link id."

      # creating a sample link to test edit action
      lnk  = Link.create(:title => "some title",:link => "http://gmail.co.in",:tag_id => 1, :group_id => 1,:user_id => 1)
      # checking the edit action with proper id
      get :edit, :id => lnk.id
      assert_response :success
      assert assigns(@link), "The edit action is not rendered properly"

      # requesting create action with any parameters
      get :create
      assert_response :redirect
      assert_redirected_to :action => "index"

      post :create
      assert_response :redirect
      assert_redirected_to :action => "index"

      # posting values to the link create without tag
      post :create, :link => {:title => "some title new", :link=> "http://yahoo.co.in", :description => "some description here"}
      assert_response :success
      assert_equal @response.body, "Tag can't be blank", "The link is created with post values without tag"

      # posting values to the link create without new tag
      post :create, :link => {:title => "some title new", :link=> "http://yahoo.com.in", :description => "some description here"} , :newtag => "newtag23"
      assert_response :success
      assert_equal @response.body, "success", "The link is not created with proper values"

      assert_not_nil Tag.find_by_name("newtag23")

      # requesting quick entry without parameters
      get :quickentry
      assert_response :success
      assert_equal assigns(@message)[:status].to_s, "Oops! unable to add Blendmark due to invalid token values passed."

      # requesting quick entry with url, without key
      get :quickentry, :url => "http://abcd.com"
      assert_response :success
      assert_equal assigns(@message)[:status].to_s, "Oops! unable to add Blendmark due to invalid user token value passed."

      # requesting quick entry with url, with wrong key
      get :quickentry, :url => "http://abcd.com", :key => "sdfgsadf"
      assert_response :success
      assert_equal assigns(@message)[:status].to_s, "Oops! unable to add Blendmark due to invalid user token value passed."


      # requesting quick entry with url, with key, without title
      get :quickentry, :url => "http://abcd.com", :key => User.first.bookmarkletcode.to_s
      assert_response :success
      assert_equal assigns(@message)[:status].to_s, "Oops! Title can't be blank"

      # requesting quick entry with url, with key, with title
      get :quickentry, :url => "http://abcd.com", :key => User.first.bookmarkletcode.to_s, :title => "some link for testing"
      assert_response :success
      assert_equal assigns(@message)[:status].to_s, "success", "Bookmarklet link is not created with proper values."

      # requesting add tag action without values
      get :addtag
      assert_response :success
      assert_equal @response.body.to_s, "Oops! something wrong happened!", "The tag action is malfunctioning."

      # requesting add tag action with description
      get :addtag , :description => "some tag description"
      assert_response :success
      assert_equal @response.body, "Oops! something wrong happened!", "The tag action is malfunctioning."

      # requesting add tag action with title
      get :addtag , :name => "tag1234"
      assert_response :success
      assert_equal @response.body, "success#" + Tag.last.id.to_s , "The tag action is malfunctioning."

      # requesting add tag action with title
      get :addtag , :name => "tag12345", :description => "some description"
      assert_response :success
      assert_equal @response.body, "success#" + Tag.last.id.to_s , "The tag action is malfunctioning."

      # requesting link update action without values
      get :update
      assert_response :redirect
      assert_redirected_to :controller => "links", :action => "index"

      # requesting link update action with id
      get :update, :id => Link.first.id
      assert_response :redirect
      assert_redirected_to :controller => "links", :action => "index"

      # requesting link update action with link without id
      get :update, :link => Link.first.attributes
      assert_response :redirect
      assert_redirected_to :controller => "links", :action => "index"

      # requesting link update action with link and id
      get :update, :id => Link.first.id , :link => Link.first.attributes
      assert_response :success
      assert_equal @response.body , "Link was successfully updated." , "Link is not updated properly"

      # requesting destroy action to delete link without passing id
      get :destroy
      assert_response :success
      assert_equal @response.body , "invalid parameter passed."

      # requesting destroy action to delete link with passing invalid id
      get :destroy, :id => 34957
      assert_response :success
      assert_equal @response.body , "invalid parameter passed."

      # requesting destroy action to delete link with passing valid id
      id = Link.first.id
      get :destroy, :id => id
      assert_response :success
      assert_equal @response.body , "success"
      assert_nil Link.find_by_id(id), "The link is not destroyed successfully."

      # requesting readlinksfrommail action without parameters
      get :readlinksfrommail
      assert_response :success
      assert_equal @response.body , "invalid parameters passed."

      # requesting readlinksfrommail action with parameter plain
      get :readlinksfrommail, :plain => "some long text here to get all the links from this text, the links might be insde the para , http://sdfgdsfg.com, http://eruitywer.com.co.in"
      assert_response :success
      assert_equal @response.body , "invalid parameters passed."

      # requesting readlinksfrommail action with required parameters
      get :readlinksfrommail,:subject => "some subject text here", :plain => "some long text here to get all the links from this text, the links might be inside the para , http://sdfgdsfg.com, http://eruitywer.com.co.in"
      assert_response :success
      assert_equal @response.body , "success"

      # requesting tagautocomplete action without required parameters
      get :tagautocomplete
      assert_response :success
      assert_equal @response.body , "invalid parameter passed."

      # requesting tagautocomplete action with required parameters
      get :tagautocomplete, :query => "tag"
      assert_response :success
      res = ActiveSupport::JSON.decode (@response.body)
      assert_equal res, {"query"=>"tag", "suggestions"=>["tag1234", "tag12345"], "data"=>[]}
      #assert_equal res[:suggestions][0].to_s , "tag1234"
      #assert_equal res[:suggestions][0].to_s , "tag12345"

	  
	  
  end

  def set_login

        group = Group.new
        group.title = "test"
        if group.save
          user = group.user.new
          user.username = "santhosh@itxsolutionsindia.com"
          user.email = "santhosh@itxsolutionsindia.com"
          user.password = "password@123"
          user.password_confirmation = "password@123"
          user.isnotificationsubscribed = true
          user.bookmarkletcode = User.random_string(10)
          unless user.save
            puts user.errors.full_messages()
          end
        end
        user = UserSession.create(:username => "santhosh@itxsolutionsindia.com", :password => "password@123", :remember_me => true)
        unless user.save
          puts user.errors.full_messages()
        end
        assert user.save, "User session not saved."
  end

end