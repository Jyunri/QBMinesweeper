require 'sinatra'

require './iohandler.rb'
require './printers.rb'
require './minesweeper.rb'
require 'pry'

include IOHandler

# Routes
get '/' do
  erb :new
end

post '/new' do
  row = params['row_count'].to_i
  col = params['col_count'].to_i
  bombs = params['bomb_count'].to_i
  $m = Minesweeper.new(row, col, bombs)
  erb :index
end

get '/check/:row/:col' do
  row = params['row'].to_i
  col = params['col'].to_i
  $m.mine_field[row, col].check_cell($m)
  erb :index
end

get '/flag/:row/:col' do
  row = params['row'].to_i
  col = params['col'].to_i
  $m.mine_field[row, col].set_flag
  erb :index
  # redirect '/'
end

get '/xray' do
  erb :xray_view
end
