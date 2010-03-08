require 'rubygems'
require 'json'
require 'net/http'

DETECT_API_PARAMS = {'v'=>'1.0', 'q'=>''}
DETECT_URL = 'http://ajax.googleapis.com/ajax/services/language/detect?'


def lang_detect(text)
    detect_params = DETECT_API_PARAMS.dup
    detect_params['q'] = URI.escape(text)
    uri_encoded_params = ''
    detect_params.each do |k,v|
      uri_encoded_params << "#{k}=#{v}&"
    end
    url = DETECT_URL + uri_encoded_params.chop
    response = JSON.parse(Net::HTTP.get(URI.parse(url)))    
    data = response['responseData']
    return data
end

def lang_process_tweet(tweet)
  if tweet.language
    return tweet.language
  else
    begin
      lang_data = lang_detect(tweet.text)
      language = Language.new(:iso_lang_code => lang_data["language"], :tweet_id => tweet.id, :confidence => lang_data["confidence"], :is_reliable? => lang_data["isReliable"])
      language.save
      return tweet.language
    rescue
      puts "error processing tweet. moving on. Google data: #{lang_data.inspect}"
    end
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
