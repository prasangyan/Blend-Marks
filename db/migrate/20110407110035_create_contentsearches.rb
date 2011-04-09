class CreateContentsearches < ActiveRecord::Migration
  def self.up
    add_column "links", "content", "text"
    add_column "links", "title", "text"
  end
  def self.down
    remove_column "links", "content"
    remove_column "links", "title"
  end
end
