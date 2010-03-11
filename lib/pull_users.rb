require 'ruby-debug'
Object.send :undef_method, :id

auth_info = YAML::load(File.open("#{File.dirname(__FILE__)}/../config/pork_config.yml"))
$AUTH = Pork::Auth.new(auth_info["twitter_auth"]["username"],auth_info["twitter_auth"]["password"])

def pull_user(user, via)
  @user = Pork::TwitterUser.new(:twitter_screen_name => user)
  @user.pull_account_info
  if @user.db_object
    @db_id = @user.db_object.id 
    AccountMetadata.create(:acquired_via => via, :twitter_account_id => @db_id, :account_info_updated => Time.now)
  else
    debugger
    nil
  end
end

Username.all.each do |u|
  pull_user(u.username,u.via)
  u.delete
end


