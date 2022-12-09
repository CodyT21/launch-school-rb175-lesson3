require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "yaml"

before do
  @users_and_interests = YAML.load_file('users.yaml')
end

get '/' do
  @users = @users_and_interests.keys

  erb :home
end

get '/:name' do
  name = params[:name].to_sym
  @email = @users_and_interests[name][:email]
  @interests = @users_and_interests[name][:interests]

  erb :user
end

helpers do
  def count_users
    @users_and_interests.keys.size
  end

  def count_interests
    @users_and_interests.reduce(0) do |sum, (user, user_info)|
      sum + user_info[:interests].size
    end
  end
end