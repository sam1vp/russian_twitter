class CreateUserMetadataTable < ActiveRecord::Migration
  def self.up
    create_table :account_metadatas do |t|
      t.integer :twitter_account_id
      t.timestamp :account_info_updated
      t.string :acquired_via
      t.timestamp :latest_tweet_pulled
      t.integer :tweet_id
      t.timestamp :followers_pulled
      t.timestamp :friends_pulled
      t.boolean :located_in_russia
      t.boolean :tweets_in_russian
    end
  end

  def self.down
    drop_table :account_metadatas
  end
end
