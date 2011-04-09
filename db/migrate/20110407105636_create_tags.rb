class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
      t.text :description
      t.integer :link_id
      t.timestamps
    end
  end
  def self.down
    drop_table :tags
  end
end
