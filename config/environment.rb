# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
BlendMarks::Application.initialize!

ENV["mail_username"] = "support@blendmarks.com"
ActionMailer::Base.smtp_settings = {
        :enable_starttls_auto => true,
        :address => "smtp.gmail.com",
        :port => "587",
        :user_name => "interestinglinks@itxsolutionsindia.com",
        :password => "password@123",
        :authentication => :plain,
        :smtp => true
  }
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_content_type = "text/html"

ENV['INDEXTANK_API_URL'] = 'http://:vnNWPQglltomb3@xba3.api.indextank.com'
ENV['INDEXTANK_INDEX'] = 'idx'


