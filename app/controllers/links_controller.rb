require "mail"
class LinksController < ApplicationController
  before_filter "isuserloggedin" , :except => [:quickentry]
  before_filter "setsubdomainasgroup"
  protect_from_forgery :except => [:addtag,:search,:readlinksfrommail,:quickentry]

  def index
    #flash[:notice] = "welcome to interesting links."
    if session[:id].nil?
      session[:id] = params[:id]
    end
    unless session[:id].nil?
      #puts session[:id]
      redirect_to :action => "new"
      return
    end
    if @pattern.nil?
       @links = Link.find(:all,:conditions => "group_id = '#{session[:group]}'", :order => "id desc")
    else
      tag = @tagsearch
      if tag == 0
        tag = 1
      end
       @links = Link.find(:all,:conditions => "group_id = '#{session[:group]}'", :order => "id desc") #Link.find(:all, :conditions => "(link ~* '#{@pattern}' or description ~* '#{@pattern}') and tag = '#{@tagsearch}'")
    end
    @tag = Tag.new
    @tags = {}
    Tag.all.each do |tag|
      @tags[tag.id] = tag.name
    end
    flash[:filter] = false
  end

  def search
    begin
      @pageindex = 1
      unless params[:pageindex].nil?
        @pageindex = params[:pageindex].to_i
      end
      @criteria = params[:criteria]
      # searching with the default text comparisons
      result = Link.find(:all, :conditions => "content like '%#{@criteria}%'")  #Yml.search_hash(@criteria)
      @result = []
      result.each do |res|
        @result.push(res)
      end
      # searching with Index Tank
      client = IndexTank::Client.new(ENV['INDEXTANK_API_URL'] || 'http://:vnNWPQglltomb3@xba3.api.indextank.com')
      index = client.indexes(ENV['INDEXTANK_INDEX'])
      result = index.search(@criteria)
      result.each do |res|
        @result.push(Link.find(:first,:conditions => "id = #{res['docid']}"))
      end
    end
  end

  def sendnotification
    Notificationlink.all.each do |link|
      #User.find(:all, :conditions => "isnotificationsubscribed = true").each do |user|
      User.all.each do |user|
        UserMailer.deliver_linknotification(link,user,current_user)
      end
      link.destroy
    end
    render :text => "success"
  end

  def new
    @link = Link.new
  end

  def edit
    @link = Link.find(params[:id])
  end

  def create
    @link = Link.new(params[:link])
    newtag = params[:newtag]
    tag = Tag.find(:first,:conditions => "name = '#{newtag}'")
    if tag.nil?
      tag = Tag.new
      tag.name = newtag
      tag.save
    end
    @link.tag_id = tag.id
    @link.user_id = current_user.id
    @link.group_id=session[:group]
    if @link.save
      render :text => "success"
    else
      render :text => @link.errors.full_messages[0]
    end
    #redirect_to :action => "index"
  end

  def quickentry
    url = params[:url]
    userbookmarkletkey = params[:key]
    tagname = 'unknown'
    unless id.nil? and userbookmarkletkey.nil?
      user = User.find(:first, :conditions => "bookmarkletcode = '#{userbookmarkletkey}'")
      unless user.nil?
        link = Link.new
        link.link = url
        link.title = url
        tag = Tag.find(:first, :conditions => "name = '#{tagname}'")
        if tag.nil?
          tag = Tag.new
          tag.name = tagname
          tag.save
        end
        link.tag_id = tag.id
        link.user_id = user.id
        unless link.save
        end
      end
    end
    render :text => "success"
  end

  def addtag
    @tag = Tag.new
    @tag.name = params[:name]
    @tag.description = params[:description]
    @tag.name
    if @tag.save
      render :text => "success#" + @tag.id.to_s
    else
      render :text => "hoop! something wrong happened!"
    end
    #redirect_to :action => "index"
  end

  def update
    @link = Link.find(params[:id])
    respond_to do |format|
      if @link.update_attributes(params[:link])
        format.html { redirect_to(@link, :notice => 'Link was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy
    respond_to do |format|
      format.html { redirect_to(links_url) }
      format.xml  { head :ok }
    end
  end

  def readlinksfrommail
    message = params[:plain] #Mail.new(params[:message])
    #urls = message.subject.to_s.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix) #message.subject.to_s.split(/\s+/).find_all {|u| u=/^https?:/}
    urls = message.to_s.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
    message = saveurls(urls,message);
    urls = message.to_s.scan(/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
    saveurls(urls,message)
    message = params[:subject]
    #urls =  message.body.to_s.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)  #message.body.to_s.split(/\s+/).find_all {|u| u=/^https?:/}
    urls =  message.to_s.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
    message = saveurls(urls,message)
    urls = message.to_s.scan(/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
    saveurls(urls,message)
    render :text => "success"
  end

  def saveurls(urls,originalmessage)
    urls.each do |url|
      link = Link.new
      link.link = url
      link.description = "Received from mail"
      link.tag = 1
      link.save
      begin
        originalmessage = originalmessage.sub(url,'')
      rescue
      end
    end
    return originalmessage
  end

end
