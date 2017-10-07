require 'sinatra'
require 'sinatra/flash'

enable :sessions

require './iohandler.rb'
require './printers.rb'
require './minesweeper.rb'
require 'pry'

include IOHandler

# Define a project instance for user game. Using this class to prevent globals.
class Application
  attr_accessor :minesweeper, :rows, :cols, :bombs

  def initialize(rows, cols, bombs)
    @rows = rows
    @cols = cols
    @bombs = bombs
    @minesweeper = Minesweeper.new(rows, cols, bombs)
  end
end

# Routes
get '/' do
  erb :new
end

post '/new' do
  row = params['row_count'].to_i
  col = params['col_count'].to_i
  bombs = params['bomb_count'].to_i
  if row < 1 || col < 1 || bombs < 1 || bombs > row * col
    flash[:error] = 'Invalid input!'
    redirect('/')
  else
    $m = Minesweeper.new(row, col, bombs)
    erb :index
  end
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
