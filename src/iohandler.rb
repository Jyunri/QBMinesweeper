require './minesweeper.rb'
require 'json'
require 'pry'

# Module to handle IO data
module IOHandler
  def menu
    menu = "Menu:\
    \nc: Check cell\
    \nf: Set/Unset flag\
    \np: Change print style\
    \nx: Print x-ray field\
    \ns: Save game\
    \nl: Load game\
    \ne: Exit program\n"

    puts menu
  end

  def input_validation(input = {})
    raise ArgumentError, 'Row is less than 0' unless input[:rows] > 0
    raise ArgumentError, 'Column is less than 0' unless input[:cols] > 0
    raise ArgumentError, 'Bombs is less than 0' unless input[:bombs] > 0
  end

  def new_game_input
    puts 'Enter with number of rows'
    input_rows = gets.to_i
    puts 'Enter with number of columns'
    input_columns = gets.to_i
    puts 'Enter with number of bombs'
    input_bombs = gets.to_i

    input_validation(rows: input_rows, cols: input_columns, bombs: input_bombs)

    Minesweeper.new(input_rows, input_columns, input_bombs)
  end

  def save_game(board_state)
    File.open('savefile.json', 'w') do |f|
      f.write(JSON.pretty_generate(board_state, indent: "\t"))
    end
  end

  def load_game(game, savefile)
    file = File.read(savefile)
    board_state = JSON.parse(file)
    game.row = board_state['row_count']
    game.col = board_state['col_count']
    game.clear_cell_count = board_state['clear_count']
    game.bombs_count = (game.row * game.col) - game.clear_cell_count

    field = board_state['field'].tr('#', 'b')
    game.mine_field = load_field(game, field)
  end

  def load_field(game, field)
    # bad method to parse board_state. Trying to avoid this eval thing!
    # a = eval field
    step = 0
    type_hash = {
      x: -1,
      b: 1
    }
    Matrix.build(game.row + 2, game.col + 2) do |r, c|
      type = type_hash.fetch(field[step].to_sym, 0)
      status = field[step + 1].to_i
      bombs_in_neighborhood = field[step].to_i
      step += 3
      Cell.new(r, c, type, status, bombs_in_neighborhood)
    end
  end
end
