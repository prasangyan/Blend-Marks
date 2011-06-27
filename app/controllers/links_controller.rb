require "mail"
require "indextank"
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
      @criteria = params[:criteria]
      # searching with the default text comparisons
      result = Link.find(:all, :conditions => "content like '%#{@criteria}%'")  #Yml.search_hash(@criteria)
      @links = []
      result.each do |res|
        @links.push(res)
      end
      # searching with Index Tank
      client = IndexTank::Client.new('http://:ZugDaAAC61N0k8@drxq3.api.indextank.com')
      index = client.indexes('idx')
      result = index.search(@criteria)
      puts result
      unless result["results"].nil?
        res = result["results"]
        begin
          res.each do |rs|
            begin
              lnk = Link.find(:first,:conditions => "id = #{rs["docid"].to_s}")
              unless lnk.nil?
                @links.push(lnk)
              end
            end
          end
        rescue
        end
      end
    end
    render :index
  end

  def tagfilter
    begin
      tag = params[:tag]
      @links = []
      unless tag.empty? && tag.nil?
        tags = Tag.where("lower(name) = '#{tag.to_s.downcase}'")
        if(tags.count() > 0)
          tagid =tags[0].id
          # searching with the tag id
          result = Link.find(:all, :conditions => "tag_id = '#{tagid}'")
          result.each do |res|
            @links.push(res)
          end
        end
      end
    end
    render :index
  end

  def sendnotification
    delivernotifications
    render :text => "success"
  end

  def new
    @link = Link.new
    render :layout => false 
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
      delivernotifications
      render :text => "success"
    else
      render :text => @link.errors.full_messages[0]
    end
    #redirect_to :action => "index"
  end

  def quickentry
    @status = ""
    url = params[:url]
    userbookmarkletkey = params[:key]
    tagname = 'unknown'
    unless url.nil? and userbookmarkletkey.nil?
      user = User.find(:first, :conditions => "bookmarkletcode = '#{userbookmarkletkey}'")
      unless user.nil?
        link = Link.new
        link.link = url
        link.title = params[:title]
        tag = Tag.find(:first, :conditions => "name = '#{tagname}'")
        if tag.nil?
          tag = Tag.new
          tag.name = tagname
          tag.save
        end
        link.tag_id = tag.id
        link.user_id = user.id
        link.group_id = user.group_id
        unless link.save
          puts link.errors.full_messages
          @status = "Oops! This Blendmark already exists."
        else
          delivernotifications
          @status = "success"
        end
      else
        @status = "Oops! unable to add Blendmark due to invalid user token value passed."
      end
    else
      @status = "Oops! unable to add Blendmark due to invalid token values passed."
    end
    render :layout => false
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

  def tagautocomplete
    query = params[:query]
    result = {}
    result[:query] = query
    suggestions = []
    Tag.where("lower(name) like '#{query}%'").each do |tag|
      suggestions.push(tag.name)
    end
    result[:suggestions] = suggestions
    result[:data] = []
    render :json => result
  end

  private
  def delivernotifications
    if(ENV['RAILS_ENV'].to_s != "development")
      Notificationlink.all.each do |link|
        #User.find(:all, :conditions => "isnotificationsubscribed = true").each do |user|
        User.all.each do |user|
          UserMailer.deliver_linknotification(link,user,current_user,Group.find(:first,:conditions => "id = '#{session[:group]}'").title)
        end
        link.destroy
      end
    end
  end
end
