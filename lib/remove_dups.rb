count = 0 

tweets = Tweet.all.inject({}) do |result,tweet| 
  result[tweet.id] = tweet.status_id
  result
end

tweets.each do |id, status_id| 
	tweets.delete(id)
	if tweets.each_value.include?(status_id)
		Tweet.find(id).destroy
		count += 1
	end
end

puts "#{count} duplicate tweets removed"