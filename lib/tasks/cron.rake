require "net/http"
require "net/https"
require "rubygems"
require "sanitize"
require 'indextank'
require 'uri'
task :cron => :environment do
    client = IndexTank::Client.new('http://:ZugDaAAC61N0k8@drxq3.api.indextank.com')
    index = client.indexes('idx')
    counter = 1
    Link.where(:content => nil).each do |lnk|
      begin
        puts lnk[:link]
        uri = URI.parse(lnk[:link])
        if uri.scheme.to_s = "http"
          @result = Net::HTTP.get(uri)
        else if uri.scheme.to_s = "https"
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl=true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Get.new(uri.request_uri)
          @result = http.request(request)
        end
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
      end
      rescue Exception => ex
        puts "Error on web content scrabing due to " + ex.message
      end
      counter += 1
      if counter > 25
        break
      end
    end
end

