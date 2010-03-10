require 'rubygems'
require 'json'
require 'net/http'

# commented out values are for the google api
DETECT_API_PARAMS = {'outputMode' => "json",'apikey' => YAML::load(File.open("#{File.dirname(__FILE__)}/../config/pork_config.yml"))["alchemy_api_key"]}   #{'v'=>'1.0', 'q'=>''}
DETECT_URL = 'http://access.alchemyapi.com/calls/text/TextGetLanguage?'  #'http://ajax.googleapis.com/ajax/services/language/detect?'
TEXT_PARAM = 'text' # 'q'
API = 'alchemy' #'google'
API_DAILY_RATE = 30_000

def lang_detect(text)
    detect_params = DETECT_API_PARAMS.dup
    detect_params[TEXT_PARAM] = URI.escape(text)
    uri_encoded_params = ''
    detect_params.each do |k,v|
      uri_encoded_params << "#{k}=#{v}&"
    end
    url = DETECT_URL + uri_encoded_params.chop
    response = JSON.parse(Net::HTTP.get(URI.parse(url)))    
    return response
end



def lang_process_tweet(tweet)
  if tweet.language
    return tweet.language
  else
    start_time = Time.now
    begin
      lang_data = lang_detect(tweet.text)
      if API == 'google'
        language = Language.new(:iso_lang_code => lang_data["language"], :tweet_id => tweet.id, :confidence => lang_data["confidence"], :is_reliable => lang_data["isReliable"])
      elsif API == 'alchemy'
        iso_code = lang_data["iso-639-1"]? lang_data["iso-639-1"] : lang_data["language"]
        language = Language.new(:iso_lang_code => iso_code, :tweet_id => tweet.id, :is_reliable => true)
      end
      language.save
    rescue
      puts "error processing tweet. moving on. Data: #{lang_data.inspect}"
      if not lang_data
        sleep 600
      end
    end
    pause_time = (API_DAILY_RATE/24.0/60.0/60.0 - (Time.now - start_time))
    sleep pause_time if pause_time > 0
    return tweet.language
  end
end

def lang_all_tweets
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
end
