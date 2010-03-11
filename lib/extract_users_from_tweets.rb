require 'pork_sandwich'
require 'ruby-debug'



def extract_user(tweet)
  name = tweet.from_user
  via = tweet.tags.first.name
  if !TwitterAccount.find_by_screen_name(name) and (tweet.language.iso_lang_code == 'ru')
   Username.create(:username => name, :via => via) 
  end
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

