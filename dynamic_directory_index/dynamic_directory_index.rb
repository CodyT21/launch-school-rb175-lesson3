require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "Dynamic Directory Index"
  @contents = Dir.glob("./public/*").sort do |a, b|
    if params["sort"] == "desc"
      b <=> a
    else
      a <=> b
    end
  end

  erb :home
end


