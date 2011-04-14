class Group < ActiveRecord::Base
    has_many :links
    has_many :user
    validates_presence_of :title
    validates_uniqueness_of :title
end
