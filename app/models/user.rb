require 'digest/sha1'
class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :link
  belongs_to :group
  validates_presence_of :username, :email, :group_id
  validates_uniqueness_of :username, :email
  before_save :setbookmartletcode

  def send_reset_password
    reset_code = User.random_string(10)
    self.reset_code = reset_code
    self.save
    UserMailer.deliver_forgot_password(self, reset_code)
  end

  def send_invitation
    reset_code = User.random_string(10)
    self.reset_code = reset_code
    self.save
    UserMailer.deliver_invitation(self, reset_code,self.group.title)
  end

  protected
  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def setbookmartletcode
      self.bookmarkletcode = User.random_string(10)
  end

end
