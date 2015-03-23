class ChangeUserIndexByEmail < ActiveRecord::Migration
  def up
    remove_index :users, :email
    add_index :users, [:email, :subdomain], unique: true
  end

  def down
    remove_index :users, [:email, :subdomain]
    add_index :users, :email
  end
end
