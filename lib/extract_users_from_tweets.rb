require 'pork_sandwich'

auth_info = YAML::load(File.open("#{File.dirname(__FILE__)}/../config/pork_config.yml"))
$AUTH = Pork::Auth.new(auth_info["twitter_auth"]["username"],auth_info["twitter_auth"]["password"])

def extract_user(tweet)
  name = tweet.from_user
  via = tweet.tags.first.name
  if !TwitterAccount.find_by_screen_name(name) and (tweet.language.iso_lang_code == 'ru')
   $users_to_pull[name] = via 
  end
  return $users_to_pull
end

def pull_users(users)
  users.each do |k,v|
    pull_user(k,v)
  end
end

def pull_user(user, via)
  user = Pork::TwitterUser.new(:twitter_screen_name => user)
  user.pull_account_info
  db_id = user.db_object.id if user.db_object
  AccountMetadata.create(:acquired_via => via, :twitter_account_id => db_id, :account_info_updated => Time.now) if user.db_object
end

i = 1000
count = 0
total = Tweet.all.size
$users_to_pull = {}
loop do
 tweet_set = Tweet.all(:conditions => "id >= #{i - 1000} and id < #{i}")
 if count == total
   break
 end
 tweet_set.each do |tweet|
   if !tweet.tags.empty? and tweet.language
     extract_user(tweet)
   end
   count += 1
 end
 i += 1000
 puts "tweets processed = #{count}"
end
puts "User list created, pulling #{$users_to_pull.size} user accounts"
pull_users($users_to_pull)
