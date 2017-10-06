require 'pry'
require 'matrix'

# Representation of a Game
class Minesweep
  attr_accessor :mine_field, :row, :col, :bombs_count, :clear_cell_count,
                :game_over

  def initialize(row, col, bombs_count)
    @row = row
    @col = col
    @bombs_count = bombs_count
    @clear_cell_count = @row * @col - @bombs_count
    @game_over = false
    @mine_field = generate_field
    set_bombs
  end

  def generate_field
    borders = [0, row + 1, col + 1]
    Matrix.build(row + 2, col + 2) do |r, c|
      # check if is a border cell
      if borders.include?(r) || borders.include?(c)
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
  end

  def board_state(opt = {})
    field = Matrix.build(@row + 2, @col + 2) do |r, c|
      cell_type = @mine_field[r, c].type.to_s
      cell_status = @mine_field[r, c].status.to_s
      cell_bomb_count =  @mine_field[r, c].bombs_in_neighborhood.to_s
      cell_hash = { type: cell_type, status: cell_status,
                    bombs_count: cell_bomb_count  }
    end

    state = { row_count: @row, col_count: @col, hidden: opt[:xray],
              clear_count: @clear_cell_count, field: field }

  end
end

# Representation of a Cell/Button.
# A Cell can be a Bomb, a Border or a Clear Cell.
# Furthermore, it can be Checked, Unchecked or Flagged
class Cell
  attr_accessor :row, :col, :type, :status, :hasFlag, :bombs_in_neighborhood

  def initialize(row, col, type, status)
    @row = row
    @col = col
    @type = type
    @bombs_in_neighborhood = 0
    @status = status
  end

  def check_cell(game)
    if bomb?
      game.game_over = true
    elsif unchecked?
      @status = 1
      game.clear_cell_count -= 1
      puts "Nice! There's still #{game.clear_cell_count} clear cells left!"
      expand_neighborhood(game) if bombs_in_neighborhood.zero?
    else
      puts 'Invalid position!'
    end
  end

  def expand_neighborhood(game)
    (row - 1..row + 1).each do |r|
      (col - 1..col + 1).each do |c|
        next if r == row && c == col
        cell = game.mine_field[r, c]
        next if cell.checked?
        cell.status = 1
        game.clear_cell_count -= 1
        cell.expand_neighborhood(game) if cell.expandable?
      end
    end
  end

  def set_flag
    if flagged?
      @status = 0
      puts "Flag unset from position (#{@row},#{@col})"
    elsif unchecked?
      @status = 2
      puts "Flag set on position (#{@row},#{@col})"
    else
      puts 'Invalid position!'
      false
    end
  end

  # TODO: try to convert this in something like #define BORDER -1
  # type conventions
  def border?
    return true if @type == -1
  end

  def clear?
    return true if @type.zero?
  end

  def bomb?
    return true if @type == 1
  end

  # status conventions
  def checked?
    return true if @status == 1
  end

  def unchecked?
    return true if @status.zero?
  end

  def flagged?
    return true if @status == 2
  end

  def expandable?
    return true if @bombs_in_neighborhood.zero? && clear?
  end

  def to_s
    if border?
      'x'
    elsif bomb?
      '#'
    else
      bombs_in_neighborhood.to_s
    end
  end
end

# Simple printer class. Just a non-friendly representation
class Printer
  attr_accessor :board_state
  def initialize(board_state)
    @board_state = board_state
  end

  def xray_print
    puts 'X-ray field:'
    (0..@board_state.row + 1).each do |i|
      (0..@board_state.col + 1).each do |j|
        print "#{@board_state.mine_field[i, j]}\t"
      end
      puts
    end
    puts
  end

  def current_print
    puts 'Current state of field:'
    (0..@board_state.row + 1).each do |i|
      (0..@board_state.col + 1).each do |j|
        if @board_state.mine_field[i, j].checked?
          print "#{@board_state.mine_field[i, j]}\t"
        elsif @board_state.mine_field[i, j].flagged?
          print "F\t"
        else
          print "?\t"
        end
      end
      puts
    end
    puts
  end
end

# Simple printer class. Just a non-friendly representation
class SimplePrinter
  attr_accessor :board_state
  def initialize(board_state)
    @board_state = board_state
  end

  def cell_print(cell)
    cell_type  = cell[:type]
    if cell_type == "-1"
      'x'
    elsif cell_type == "1"
      '#'
    else
      cell[:bombs_count].to_s
    end
  end

  def xray_print
    puts 'X-ray field:'
    (0..@board_state[:row_count] + 1).each do |i|
      (0..@board_state[:col_count] + 1).each do |j|
        # cell_status = "#{@board_state[:field][i, j][:status]}"
        cell  = @board_state[:field][i, j]
        print "#{cell_print(cell)}\t"
      end
      puts
    end
  end

  def current_status_print
    puts "Current print:"
  end

  def print_state
    row_count = @board_state[:row_count]
    col_count = @board_state[:col_count]
    hidden = @board_state[:hidden]

    if(hidden)
      xray_print
    else
      current_status_print
    end

    puts
  end
end

def new_game_input
  puts 'Enter with number of rows'
  input_rows = gets.to_i
  puts 'Enter with number of columns'
  input_columns = gets.to_i
  puts 'Enter with number of bombs'
  input_bombs = gets.to_i

  raise ArgumentError, 'Row is less than 0' unless input_rows > 0
  raise ArgumentError, 'Column is less than 0' unless input_columns > 0
  raise ArgumentError, 'Bombs is less than 0' unless input_bombs > 0

  Minesweep.new(input_rows, input_columns, input_bombs)
end

g = new_game_input

Printer.new(g).current_print

loop do
  menu = "Menu:\
    \nc: Check cell\
    \nf: Set/Unset flag\
    \np: Print current state of field\
    \nx: Print x-ray field\
    \ne: Exit programn\n"
  puts menu
  print_mode = gets.chomp
  puts
  case print_mode
  when 'c'
    g.game_check_cell
    puts
    Printer.new(g).current_print
  when 'f'
    g.game_set_flag
    puts
    Printer.new(g).current_print
  when 'x'
    SimplePrinter.new(g.board_state(xray:true)).print_state
  when 'p'
    Printer.new(g).current_print
  end
  puts
  break if print_mode == 'e' || !g.still_playing?
end

puts

puts 'Game Over!'
if g.victory?
  puts 'You win!'
else
  puts 'You Lose!'
end
puts
Printer.new(g).xray_print()

g.board_state
