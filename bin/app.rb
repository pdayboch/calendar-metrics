require 'sinatra'
require 'tilt/erb'
require './lib/cal.rb'
require 'fileutils'
require 'chartkick'

set :port, 8080
set :bind, '10.92.135.204'
set :static, true
set :public_folder, "static"
set :views, "views"


get '/' do
  api = Build.new()
  calendars = api.calendars
	erb :welcome_form, :locals => {'cals' => calendars}
end

get '/piechart' do
  data = {"Philip" => 5, "Matthew" => 15, "Greg" => 2}
  erb :chart, :locals => {'data' => data}
end


get '/geochart' do
  data = {"United States" => 5, "Italy" => 15, "France" => 2}
  erb :geo, :locals => {'data' => data}
end

post '/logout' do
  FileUtils.rm('/Users/phillipdayboch/.credentials/calendar-ruby-quickstart.json')
  redirect to('/')
end
