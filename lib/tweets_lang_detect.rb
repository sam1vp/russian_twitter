require 'lang_detect.rb'

i = 1000
count = 0
loop do
 tweet_set = Tweet.all(:conditions => "id >= #{i - 1000} and id < #{i}")
 if tweet_set.size == 0
   break
 end
 tweet_set.each do |tweet|
   lang_process_tweet(tweet)
   count += 1
 end
 i += 1000
 puts "count = #{count}"
end
puts "Language Processing Complete. Detected language of #{count} tweets"


