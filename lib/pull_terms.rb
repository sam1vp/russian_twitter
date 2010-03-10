require 'ruby-debug'

$PORK_LOG = Pork::Log.new("#{File.dirname(__FILE__)}/../log/#{Time.now.strftime('%m.%d.%Y')}_pull_terms.log")
$PORK_LOG.write("***************Started pulls at #{Time.now}**********************")

Term.all.each do |t|
  $SAVER.rules = {'tags' => {'tag' => t.term}}
  if t.latest_status_id 
    Pork::Search.new(t.term,{:since_id => t.latest_status_id}).historical_pull
  else
    Pork::Search.new(t.term).historical_pull
  end
  t.latest_status_id = Tweet.tagged_with(t.term).map {|tweet| tweet.status_id}.max
  t.save
  $PORK_LOG.write("completed #{t.term} pull")
end
$PORK_LOG.write("***************Ended pulls at #{Time.now}**********************")
