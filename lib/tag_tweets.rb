
def tag_tweets(tag)
  @tag = tag
  i = 1000
  count = 0
  loop do 
    tweet_set = Tweet.all(:conditions => "id >= #{i - 1000} and id < #{i}")
    if tweet_set.size == 0 
      break
    end
    tweet_set.each do |tweet|
      tweet.tag_list << tag
      tweet.save
      count += 1
    end
    i += 1000
  end
  puts "Tagging Complete. Added the '#{@tag}' tag to #{count} tweets"
end