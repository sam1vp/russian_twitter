$PORK_LOG = Pork::Log.new(STDOUT)

def single_depth(screen_name)
  @user = Pork::TwitterUser.new(:twitter_screen_name => screen_name)
  @user.pull_follower_ids
  puts "#{@user.twitter_screen_name} has #{@user.follower_relationship_db_ids.size} followers, starting to pull them..."
  @user.follower_relationship_db_ids.each do |db_id|
    user = Pork::TwitterUser.new(:twitter_id => TwitterAccount.find(TwitterRelationship.find(db_id).follower_id).twitter_id)
    puts "pulling follower ids for ID= #{user.twitter_id}"
    user.update_account_info
    user.pull_follower_ids
    puts "Finished pulling #{@user.twitter_screen_name}'s followers"
  end
end

