require 'pry'
require 'sinatra'
require './my_rack_middleware'

get '/' do
  params['parameter1'].to_s

  erb :index
end

get '/admin/:user_id' do
  params['user_id'].to_s
end
