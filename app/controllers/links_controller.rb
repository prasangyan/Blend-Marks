require "mail"
class LinksController < ApplicationController

  before_filter "isuserloggedin" , :except => [:quickentry]
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
    @link = Link.new
    if @pattern.nil?
       @links = Link.find(:all,:order => "id desc")
    else
      tag = @tagsearch
      if tag == 0
        tag = 1
      end
       @links = Link.find(:all, :conditions => "(link ~* '#{@pattern}' or description ~* '#{@pattern}') and tag = '#{@tagsearch}'")
    end
    @tag = Tag.new
    @tags = {}
    Tag.find(:all).each do |tag|
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
    Notificationlink.find(:all).each do |link|
      #User.find(:all, :conditions => "isnotificationsubscribed = true").each do |user|
      User.find(:all).each do |user|
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
    @link.tag = tag
    @link.tag_id = tag.id
    @link.user_id = current_user.id
    if @link.save
      #render :text => "success#" + @link.id.to_s
    else
      #render :text => "success#1"
    end
    redirect_to :action => "index"
  end

  def quickentry
    id = params[:url]
    tagname = 'unknown'
    unless id.nil?
      link = Link.new
      link.link = id
      link.title = id
      tag = Tag.find(:first, :conditions => "name = '#{tagname}'")
      if tag.nil?
        tag = Tag.new
        tag.name = tagname
        tag.save
      end
      link.tag_id = tag.id
      unless link.save
            puts link.errors.full_messages
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
