require "net/http"
require "rubygems"
require "sanitize"
require 'indextank'
task :cron => :environment do
    client = IndexTank::Client.new('http://:ZugDaAAC61N0k8@drxq3.api.indextank.com')
    index = client.indexes('idx')
    counter = 1
    Link.find(:all, :conditions => "content = '' or content = NULL").each do |lnk|
      #begin
        puts lnk[:link]
        @result = Net::HTTP.get(URI.parse(lnk[:link]))
        ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
        @result = ic.iconv(@result + ' ')[0..-2]
        @result.force_encoding('ASCII-8BIT') if defined?(Encoding) && body
        @result.force_encoding('ASCII-8BIT') if defined?(Encoding) && body && body.respond_to?(:force_encoding)
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
      #rescue Exception => ex
      #  puts "Error on web content scrabing due to " + ex.message
      #end
      counter += 1
      if counter > 25
        break
      end
    end
end
