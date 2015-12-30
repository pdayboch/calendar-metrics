require 'sinatra/base'
require 'sinatra/geckoboard'



class Testing < Sinatra::Base
  register Sinatra::Geckoboard

  set :port, 8080
  set :bind, '10.92.135.204'
  set :static, true
  set :public_folder, "static"
  set :views, "views"

  get '/pie_graph' do
    pie_chart [ { "label" => "Chuck Norris",
                  "value" => 3,
                  "colour" => "#ff9900" },
                { "label" => "Bruce Lee",
                  "value" => 0,
                  "colour" => "#ef9900" }
              ]
              
  end

  get '/line_chart' do
    line_chart [1, 3], ["value1", "value2"], ["top1", "top2"], "#ff9900"
  end
end

  Testing.run!
