terms = ['#russia','#ru', '#spb', '#rutwitter', '#moscow', '#msk', '#rostov', '#rnd', '#piter'] 

$PORK_LOG = Pork::Log.new("#{File.dirname(__FILE__)}/../log/#{Time.now.strftime('%m.%d.%Y')}_pull_terms.log")
terms.each do |t|
  $SAVER.rules = {'tags' => {'tag' => t}}
  latest_id = Tweet.tagged_with(t).map {|tweet| tweet.status_id}.max
  if latest_id 
    Pork::Search.new(t,{:since_id => latest_id}).historical_pull
  else
    Pork::Search.new(t).historical_pull
  end
  puts "completed #{t} pull"
end

