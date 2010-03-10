class AccountMetadata < ActiveRecord::Base 
  belongs_to :tweet
  belongs_to :twitter_account
end