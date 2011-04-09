class CreateUserSessions < ActiveRecord::Migration
  def self.up
    create_table :user_sessions do |t|
      t.string :username
      t.string :password
      t.boolean :remember_me
      t.timestamps
    end
    rename_column :users , "name", "username"
    add_column :users,"crypted_password", :string
    add_column :users, "password_salt" , :string
    add_column :users, "persistence_token", :string
    add_column :users, "reset_code", :string
  end
  def self.down
    drop_table :user_sessions
    rename_column :users, "username", "name"
    remove_column :users, "crypted_password"
    remove_column :users, "password_salt"
    remove_column :users, "persistence_token"
    remove_column :users, "reset_code", :string
  end
end
