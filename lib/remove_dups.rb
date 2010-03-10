tweets = Tweet.all.inject({}) do |result,tweet| 
  result[tweet.id] = tweet.status_id
  result
end
tweets.each do |id, status_id| 
	tweets.delete(id)
	if tweets.each_value.include?(status_id)
		Tweet.find(id).destroy
	end
end

Language.all.each do |l|
  begin
  Tweet.find(l.tweet_id)
  rescue ActiveRecord::RecordNotFound
    l.destroy
  end
end