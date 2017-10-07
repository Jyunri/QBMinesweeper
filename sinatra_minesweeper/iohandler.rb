require './minesweeper.rb'

# Module to handle IO data
module IOHandler
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
end
