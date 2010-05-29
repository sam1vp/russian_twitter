good_ids = TwitterAccount.find(:all, :include => :account_metadata).map{|a| a.account_metadata.id}
puts good_ids.first

AccountMetadata.all.each do |m|
  unless good_ids.include?(m.id)
    AccountMetadata.find(m.id).destroy
  end
end