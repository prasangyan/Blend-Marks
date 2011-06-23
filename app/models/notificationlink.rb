class Notificationlink < ActiveRecord::Base

  validates_presence_of :link
  validates_uniqueness_of :link


end
