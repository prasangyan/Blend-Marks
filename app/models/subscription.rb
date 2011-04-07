class Subscription < ActiveRecord::Base

  validates_presence_of :email, :message => "input email address."
  validates_format_of :email, :with => %r{^(?:[_a-z0-9|+-]+)(\.[_a-z0-9|+-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]>> +)*(\.[a-z]{2,4})$}i, :message => "invalid email format."

end
