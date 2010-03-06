class TweetLanguage < ActiveRecord::Base
  belongs_to :language
  belongs_to :tweet
end