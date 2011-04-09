# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
require "csv"

tag = Tag.new
tag.name = "General"
tag.description = "default tag"
tag.save



user = User.new
user.username = "santhosh@itxsolutionsindia.com"
user.email = "santhosh@itxsolutionsindia.com"
user.password = "password@123"
user.password_confirmation = "password@123"
user.isnotificationsubscribed = true
if user.save
else
  user.errors.each do |err|
    puts err
  end
end


# Adding existing links from csv
CSV.open("links.txt","rb").each do |row|
  link = Link.new
  link.link = row[0]
  link.description = row[1]
  link.title = row[0]
  tag = Tag.find(:all, :conditions => "name = '#{row[2].strip}'")
  if tag.count() > 0
    link.tag = tag
    link.tag_id = tag[0].id
  else
    tag = Tag.new
    tag.name = row[2].strip
    tag.description = "import from existing system"
    if tag.save

      link.tag_id = tag.id
    else
      link.tag = Tag.find(1)
      link.tag = 1
    end
  end
  link.user_id = User.find(1).id
  link.user = User.find(1)
 if link.save
 else
   link.errors.each do |err|
     puts err
   end
 end
end

=begin

user = User.new
user.username = "prashant@itxsolutionsindia.com"
user.email = "prashant@itxsolutionsindia.com"
user.password = "password@123"
user.password_confirmation = "password@123"
user.isnotificationsubscribed = true
if user.save
else
  user.errors.each do |err|
    puts err
  end
end


user = User.new
user.username = "pratap@itxsolutionsindia.com"
user.email = "pratap@itxsolutionsindia.com"
user.password = "password@123"
user.password_confirmation = "password@123"
user.isnotificationsubscribed = true
if user.save
else
  user.errors.each do |err|
    puts err
  end
end

=end