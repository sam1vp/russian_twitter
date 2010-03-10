terms = ['#russia', '#ru', '#spb', '#rutwitter', '#moscow', '#msk', '#rostov', '#rnd', '#piter']

terms.each do |t|
  $SAVER.rules = {'tags' => {'tag' => t}}
  latest_id = Tweet.tagged_with(t).map {|tweet| tweet.status_id}.max
  Pork::Search.new(t,{:since_id => latest_id})
  puts "completed #{t} pull"
end