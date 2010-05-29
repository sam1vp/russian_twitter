class Tweet < ActiveRecord::Base
  acts_as_taggable_on :tags
  belongs_to :twitter_account 
  has_and_belongs_to_many :trends  
  has_many :tweet_reactions, :dependent => :destroy
  has_one :account_metadata, :dependent => :destroy
  has_one :language, :dependent => :destroy
end