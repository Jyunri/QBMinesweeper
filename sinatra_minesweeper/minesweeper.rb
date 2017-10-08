require 'matrix'
require './cell.rb'

# Representation of a Game
class Minesweeper
  attr_accessor :mine_field, :row, :col, :bombs_count, :clear_cell_count,
                :flag_count, :game_over

  def initialize(row, col, bombs_count)
    @row = row
    @col = col
    @bombs_count = bombs_count
    @flag_count = bombs_count
    @clear_cell_count = @row * @col - @bombs_count
    @game_over = false
    @mine_field = generate_field
    set_bombs
  end

  def generate_field
    row_borders = [0, row + 1]
    col_borders = [0, col + 1]
    Matrix.build(row + 2, col + 2) do |r, c|
      # check if is a border cell
      if row_borders.include?(r) || col_borders.include?(c)
        Cell.new(r, c, -1, 1)
      else
        Cell.new(r, c, 0, 0)
      end
    end
  end

  def set_bombs
    (1..@bombs_count).each do
      random_row = random_col = 0
      loop do
        random_row = rand(@row) + 1
        random_col = rand(@col) + 1
        break if @mine_field[random_row, random_col].clear?
      end
      @mine_field[random_row, random_col].type = 1

      # recalculate the bomb count per cell dynamically
      update_bomb_count(random_row, random_col)
    end
  end

  def update_bomb_count(bomb_row, bomb_col)
    (bomb_row - 1..bomb_row + 1).each do |r|
      (bomb_col - 1..bomb_col + 1).each do |c|
        next if r == bomb_row && c == bomb_col
        cell = @mine_field[r, c]
        cell.bombs_in_neighborhood += 1 if cell.clear?
      end
    end
  end

  def victory?
    return true if @clear_cell_count.zero?
  end

  def still_playing?
    victory? || @game_over ? false : true
  end

  def game_check_cell
    puts 'Enter the row where you want check'
    input_row = gets.to_i
    puts 'Enter the column where you want to check'
    input_col = gets.to_i

    # Passing the game class as parameter to handle neighbor cells
    @mine_field[input_row, input_col].check_cell(self)

    true
  end

  def game_set_flag
    puts 'Enter the row where you want to set a flag'
    input_row = gets.to_i
    puts 'Enter the column where you want to set a flag'
    input_col = gets.to_i

    # TODO: - raise as exception if invalid row/column
    @mine_field[input_row, input_col].set_flag
    @flag_count -= 1
  end

  def board_state(opt = {})
    field = Matrix.build(@row + 2, @col + 2) do |r, c|
      cell_type = @mine_field[r, c].type
      cell_status = @mine_field[r, c].status
      cell_bomb_count = @mine_field[r, c].bombs_in_neighborhood.to_s

      { type: cell_type, status: cell_status,
        bombs_count: cell_bomb_count }
    end

    { row_count: @row, col_count: @col, hidden: opt[:xray],
      clear_count: @clear_cell_count, field: field }
  end
end
