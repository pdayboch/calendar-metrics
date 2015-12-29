require 'sinatra'
require 'tilt/erb'
require './lib/cal.rb'

set :port, 8080
set :bind, '10.92.135.204'
set :static, true
set :public_folder, "static"
set :views, "views"

get '/' do
  thing = Build.new()
  thing.setup()
  calendars = thing.calendars
  names = []
  calendars.each do |key, value|
    names.push(key)
  end
  erb :welcome_form, :locals => {'cals' => names}

end

post '/hello/' do
  greeting = params[:greeting] || "Hi there"
  name = params[:name] || "Nobody"

  erb :index, :locals => {'greeting' => greeting, 'name' => name}
end
