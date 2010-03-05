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
