class CreateUsernamesToPullTable < ActiveRecord::Migration
  def self.up
    create_table :usernames do |t|
      t.string :username
      t.string :via
    end
  end

  def self.down
    drop_table :usernames
  end
end
