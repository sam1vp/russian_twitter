require 'pork_sandwich'

auth_info = YAML::load(File.open("#{File.dirname(__FILE__)}/../config/pork_config.yml"))
$AUTH = Pork::Auth.new(auth_info["twitter_auth"]["username"],auth_info["twitter_auth"]["password"])
$PORK_LOG = Pork::Log.new(STDOUT)

def pull_user_tweets(user_object, metadata)
  options = {:twitter_screen_name => user_object.screen_name}
  options[:since_tweet_id] = metadata.tweet_id if metadata.tweet_id
  user = Pork::TwitterUser.new(options)
  $PORK_LOG.write("trying to pull tweets for #{user_object.screen_name}")
  if user_object.screen_name
    user.pull_tweets 
    AccountMetadata.update(user_object.id, :tweet_id => user.tweet_db_ids.max, :latest_tweet_pulled => Time.now)
  end
end

TwitterAccount.find(:all, :include => :account_metadata, :conditions => "account_metadatas.tweet_id IS NULL").each do |user_object|
  pull_user_tweets(user_object, user_object.account_metadata)
end

TwitterAccount.find(:all, :include => :account_metadata, :order => "account_metadatas.latest_tweet_pulled DESC").each do |user_object|
  pull_user_tweets(user_object, user_object.account_metadata)
end