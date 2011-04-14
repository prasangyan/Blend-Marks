class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :title
      t.timestamps
    end
    add_column "links", "group_id", :string
    add_column "users", "group_id", :string
  end

  def self.down
    drop_table :groups
    remove_column "links", "group_id", :string
    remove_column "users", "group_id", :string
  end
end
