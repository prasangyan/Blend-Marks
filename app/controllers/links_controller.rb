require "mail"
require "indextank"
class LinksController < ApplicationController
  before_filter "isuserloggedin" , :except => [:quickentry]
  before_filter "setsubdomainasgroup"
  protect_from_forgery :except => [:addtag,:search,:readlinksfrommail,:quickentry]
  #verify :method => :get, :except => [:create,:update]
  #verify :method => :post, :only => [:create,:update]
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
    noOfLinksperPage = ENV['NoOfLinksPerPage']
    noOfLinksSkipCount = 0
    unless params[:pageindex].nil? 
      noOfLinksSkipCount = noOfLinksperPage.to_i * params[:pageindex].to_i
    end
    if @pattern.nil?
       @links = Link.limit(noOfLinksperPage).offset(noOfLinksSkipCount).find(:all,:conditions => "group_id = '#{session[:group]}'", :order => "id desc")
    else
      tag = @tagsearch
      if tag == 0
        tag = 1
      end
       @links = Link.limit(noOfLinksperPage).offset(noOfLinksSkipCount).find(:all,:conditions => "group_id = '#{session[:group]}'", :order => "id desc") #Link.find(:all, :conditions => "(link ~* '#{@pattern}' or description ~* '#{@pattern}') and tag = '#{@tagsearch}'")
    end
    @tag = Tag.new
    
    @tags = {}
    Tag.all.each do |tag|
      @tags[tag.id] = tag.name
    end
    flash[:filter] = false
    unless params[:pageindex].nil?
       render :layout => false
    end

  end

  def search
    begin

      @criteria = params[:criteria]
      noOfLinksperPage = ENV['NoOfLinksPerPage']
      noOfLinksSkipCount = 0
      unless params[:pageindex].nil?
        noOfLinksSkipCount = noOfLinksperPage.to_i * params[:pageindex].to_i
      end

      # searching with the default text comparisons
      result = Link.find(:all, :conditions => "content like '%#{@criteria}%'")  #Yml.search_hash(@criteria)
      @links = []
      result.each do |res|
        @links.push(res)
      end

      # searching with Index Tank
      unless @criteria.nil?
        client = IndexTank::Client.new('http://:ZugDaAAC61N0k8@drxq3.api.indextank.com')
        index = client.indexes('idx')
        result = index.search(@criteria)
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
      @links = @links[noOfLinksSkipCount.to_i,noOfLinksperPage.to_i]
    end
    
    unless params[:pageindex].nil?
       render :index, :layout => false
    else
       render :index
    end
    
  end

  def tagfilter

    begin
      tag = params[:tag]
      noOfLinksperPage = ENV['NoOfLinksPerPage']
      noOfLinksSkipCount = 0
      unless params[:pageindex].nil?
        noOfLinksSkipCount = noOfLinksperPage.to_i * params[:pageindex].to_i
      end
      @links = []
      unless tag.nil?
        tags = Tag.where("lower(name) = '#{tag.to_s.downcase}'")
        if(tags.count() > 0)
          tagid =tags[0].id
          # searching with the tag id
          result = Link.limit(noOfLinksperPage).offset(noOfLinksSkipCount).find(:all, :conditions => "tag_id = '#{tagid}'")
          result.each do |res|
            @links.push(res)
          end
        end
      end
    end
    unless params[:pageindex].nil?
       render :index, :layout => false
    else
       render :index
    end
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
    unless params[:id].nil?
      @link = Link.find_by_id(params[:id])
      if @link.nil?
        redirect_to error_url
      end
    else
      redirect_to error_url
    end
  end

  def create

    unless params[:link].nil?
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
        #delivernotifications
        render :text => "success"
      else
        render :text => @link.errors.full_messages[0]
      end
    else
      redirect_to :action => "index"
    end
    
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
          #puts link.errors.full_messages
          #@status = "Oops! This Blendmark already exists."
          @status = "Oops! " + link.errors.full_messages[0].to_s
        else
          #delivernotifications
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
      render :text => "Oops! something wrong happened!"
    end
    #redirect_to :action => "index"
  end

  def update
    unless params[:id].nil?
      unless params[:link].nil?
        @link = Link.find(params[:id])
        if @link.update_attributes(params[:link])
          render :text => "Link was successfully updated."
        else
          redirect_to :controller => "links", :action => "index"
        end
      else
        redirect_to :controller => "links", :action => "index"
      end
    else
      redirect_to :controller => "links", :action => "index"
    end
  end

  def destroy
    unless params[:id].nil?
      @link = Link.find_by_id(params[:id])
      unless @link.nil?
        @link.destroy
        render :text => "success"
      else
        render :text => "invalid parameter passed."
      end
    else
      render :text => "invalid parameter passed."
    end
  end

  def readlinksfrommail
    unless params[:plain].nil?
      unless params[:subject].nil?
        message = params[:plain] #Mail.new(params[:message])
        #urls = message.subject.to_s.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix) #message.subject.to_s.split(/\s+/).find_all {|u| u=/^https?:/}
        urls = message.to_s.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
        message = saveurls(urls,message)
        urls = message.to_s.scan(/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
        saveurls(urls,message)
        message = params[:subject]
        #urls =  message.body.to_s.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)  #message.body.to_s.split(/\s+/).find_all {|u| u=/^https?:/}
        urls =  message.to_s.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
        message = saveurls(urls,message)
        urls = message.to_s.scan(/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
        saveurls(urls,message)
        render :text => "success"
      else
        render :text => "invalid parameters passed."
      end
    else
      render :text => "invalid parameters passed."
    end
  end

  def tagautocomplete
    unless params[:query].nil?
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
    else
      render :text => "invalid parameter passed."
    end
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
  def saveurls(urls,originalmessage)
    urls.each do |url|
      link = Link.new
      link.link = url
      link.description = "Received from mail"
      link.tag_id = 1
      link.save
      begin
        originalmessage = originalmessage.sub(url,'')
      rescue
      end
    end
    return originalmessage
  end
end
