require "net/http"
require "rubygems"
require "sanitize"
class ScrabcontentController < ApplicationController
  def index

    client = IndexTank::Client.new(ENV['INDEXTANK_API_URL'] || 'http://:vnNWPQglltomb3@xba3.api.indextank.com')
    index = client.indexes(ENV['INDEXTANK_INDEX'])

    counter = 1
    Link.find(:all, :conditions => "content = '' or content = NULL").each do |lnk|
      begin
        @result = Net::HTTP.get(URI.parse(lnk.link))
        ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
        @result = ic.iconv(@result + ' ')[0..-2]
        @result.force_encoding("UTF-8")
        @result =Sanitize.clean(@result)
        @result = @result.gsub(/\r\n?/, "")
        @result = @result.gsub(/\n?/, "")
        @result = @result.gsub(/\r?/, "")
        lnk.content = @result
        lnk.save

        # index tank indexing starts here
        begin
          index.document(lnk.id).add({ :text => @result })
        rescue
          puts "Error on pushing data to Index Tank due to : ",$!,"\\n"
        end

      rescue Exception => ex
        puts "Error on web content scrabing due to " + ex.message
      end
      counter += 1
      if counter > 5
        break
      end
    end
  end
end
