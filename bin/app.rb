require 'sinatra'
require 'tilt/erb'
require './lib/cal.rb'
require 'fileutils'
require 'chartkick'
enable :sessions

set :port, 80
#set :bind, '10.92.105.192'
set :static, true
set :public_folder, "static"
set :views, "views"


get '/' do
  session[:calsWanted] = ["Cisco Meraki Mini Lab 1","Cisco Meraki Mini Lab 2","Cisco Meraki Mini Lab 3"]
  session[:startDate] = Time.new(2015, 1, 1) # default start
  session[:endDate] = Time.new(2016, 1, 1) # default end
  api = Build.new(session[:calsWanted], session[:startDate], session[:endDate])
  calendars = api.calendars
  creatorEvtCnt = api.creatorEventCount
  months = api.months
	erb :welcome_form, :locals => {'startDate' => session[:startDate],
                                'endDate' => session[:endDate],
                                'calendars' => calendars,
                                'creatorCount' => creatorEvtCnt,
                                'months' => months}
end

post '/sort' do
  session[:sortByCreator] = params[:sortByCreator] if params[:sortByCreator]
  session[:sortAsc] = params[:sortAsc] if params[:sortAsc]
  if params[:startDate]
    startDate = Date._parse(params[:startDate])
    session[:startDate] = Time.new(startDate[:year], startDate[:mon], startDate[:mday])
  end
  if params[:endDate]
    endDate = Date._parse(params[:endDate])
    session[:endDate] = Time.new(endDate[:year], endDate[:mon], endDate[:mday])
  end
  api = Build.new(session[:calsWanted], session[:startDate], session[:endDate], session[:sortByCreator], session[:sortAsc])
  calendars = api.calendars
  creatorEvtCnt = api.creatorEventCount
  months = api.months
	erb :welcome_form, :locals => {'startDate' => session[:startDate],
                                'endDate' => session[:endDate],
                                'calendars' => calendars,
                                'creatorCount' => creatorEvtCnt,
                                'months' => months}
end

post '/logout' do
  FileUtils.rm('/Users/phillipdayboch/.credentials/calendar-ruby-quickstart.json')
  redirect to('/')
end
