class CreateNotificationlinks < ActiveRecord::Migration
  def self.up
    create_table :notificationlinks do |t|
      t.column :link, :string
      t.timestamps
    end
  end
  def self.down
    drop_table :notificationlinks
  end
end
