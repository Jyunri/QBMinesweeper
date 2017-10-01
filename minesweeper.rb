require 'pry'
require 'matrix'

class Minesweep
  attr_accessor :mine_field, :row, :col, :bombs_count, :clear_cell_count, :game_over

  def initialize(row,col,bombs_count)
    puts "Generating #{row}x#{col} Field.."
    @row = row
    @col = col
    @bombs_count = bombs_count
    @clear_cell_count = @row * @col  - @bombs_count
    @game_over = false
    @mine_field = Matrix.build(row+2,col+2) { |r,c|
      if((r == 0) || (c == 0) || (r == row + 1) || (c == col + 1))  # check if is a border cell
        type = -1
        status = 1
      else
        type = 0
        status = 0
      end
      Cell.new(type,status)
    }
    set_bombs()
    count_bombs_in_neighborhood()
  end

  def set_bombs()
    puts "Setting #{@bombs_count} bombs.."
    (1..@bombs_count).each { |bomb|
      bomb_row = 0
      bomb_col = 0
      loop do
        bomb_row = rand(@row)+1
        bomb_col = rand(@col)+1
        break if @mine_field[bomb_row,bomb_col].isClear()
      end
      @mine_field[bomb_row,bomb_col].type = 1
    }
  end

  def count_bombs_in_neighborhood()
    puts "Counting bombs in neighborhood for each cell"
    for i in 1..@row
      for j in 1..@col
        @mine_field[i,j].bombs_in_neighborhood += 1 if @mine_field[i-1,j-1].isBomb
        @mine_field[i,j].bombs_in_neighborhood += 1 if @mine_field[i-1,j].isBomb
        @mine_field[i,j].bombs_in_neighborhood += 1 if @mine_field[i-1,j+1].isBomb
        @mine_field[i,j].bombs_in_neighborhood += 1 if @mine_field[i,j-1].isBomb
        @mine_field[i,j].bombs_in_neighborhood += 1 if @mine_field[i,j+1].isBomb
        @mine_field[i,j].bombs_in_neighborhood += 1 if @mine_field[i+1,j-1].isBomb
        @mine_field[i,j].bombs_in_neighborhood += 1 if @mine_field[i+1,j].isBomb
        @mine_field[i,j].bombs_in_neighborhood += 1 if @mine_field[i+1,j+1].isBomb
      end
    end
  end

  def victory?
    return true if @clear_cell_count == 0
  end

  def still_playing?
    (victory? || @game_over)? false : true
  end


  # User inputs
  def check_cell()
    puts "Enter the row where you want check"
    input_row = gets.to_i
    puts "Enter the column where you want to check"
    input_col = gets.to_i

    # TODO - raise as exception if invalid row/column
    if(@mine_field[input_row,input_col].isBomb)
      puts "Oh no it's a bomb!"
      @game_over = true
      return
    elsif(@mine_field[input_row,input_col].isChecked)
      puts "Hey! This position has already been checked!"
    elsif(@mine_field[input_row,input_col].isUnchecked)
      if(@mine_field[input_row,input_col].bombs_in_neighborhood == 0)
        puts "Great! A expansion!"
        expand_neighborhood(input_row,input_col)
      end
      @mine_field[input_row,input_col].status = 1
      @clear_cell_count -= 1
      puts "Nice! It's not a bomb! There's still #{@clear_cell_count} clear cells to be discovered!"
    else
      puts "Invalid position!"
      return false
    end

    puts
    current_print()

    puts

    return true
  end

  # TODO optimize expansion
  def expand_neighborhood(r,c)
    neighbours = Matrix[[r-1,c-1],[r-1,c],[r-1,c+1],[r,c-1],[r,c+1],[r+1,c-1],[r+1,c],[r+1,c+1]]
    for i in 0...neighbours.row_count
      r_expand = neighbours[i,0]
      c_expand = neighbours[i,1]
      puts "expanding (#{r_expand},#{c_expand})"
      check_cell_from_expand(r_expand,c_expand) if mine_field[r_expand,c_expand].isExpandable
    end
  end

  def check_cell_from_expand(r,c)
    @mine_field[r,c].status = 1
    @clear_cell_count -= 1
    expand_neighborhood(r,c)  # Recursive for the next expandables
  end


  def set_flag()
    puts "Enter the row where you want to set a flag"
    input_row = gets.to_i
    puts "Enter the column where you want to set a flag"
    input_col = gets.to_i

    # TODO - raise as exception if invalid row/column
    if(@mine_field[input_row,input_col].isFlagged)
      @mine_field[input_row,input_col].status = 0
      puts "Flag unsetted from position (#{input_row},#{input_col})"
    elsif(@mine_field[input_row,input_col].isUnchecked)
      @mine_field[input_row,input_col].status = 2
      puts "Flag setted on position (#{input_row},#{input_col})"
    else
      puts "Invalid position!"
      return false
    end

    puts
    current_print()

    puts
    return true
  end

  def xray_print()
    puts "X-ray field:"
    for i in 0..@row+1
      for j in 0..@col+1
        print "#{@mine_field[i,j]}\t"
      end
      puts
    end
    puts
  end

  def current_print()
    puts "Current state of field:"
    for i in 0..@row+1
      for j in 0..@col+1
        if(@mine_field[i,j].isChecked)
          print "#{@mine_field[i,j]}\t"
        elsif(@mine_field[i,j].isFlagged)
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

class Cell
  attr_accessor :type, :status, :hasFlag, :bombs_in_neighborhood

  def initialize(type,status)
    @type = type
    @bombs_in_neighborhood = 0
    @status = status
  end

  # TODO try to convert this in something like #define BORDER -1
  # type conventions
  def isBorder
    return true if @type == -1
  end

  def isClear
    return true if @type == 0
  end

  def isBomb
    return true if @type == 1
  end

  # status conventions
  def isChecked
    return true if @status == 1
  end

  def isUnchecked
    return true if @status == 0
  end

  def isFlagged
    return true if @status == 2
  end

  def isExpandable
    return true if isUnchecked && @bombs_in_neighborhood == 0 && isClear
  end

  def to_s
    if(isBorder)
      return "x"
    elsif(isBomb)
      return "#"
    else
      return "#{bombs_in_neighborhood}"
    end
  end

end

#todo: create validations of rows, columns > 0 and bombs <= row*columns
# puts "Enter with number of rows"
# input_rows = gets.to_i
# puts "Enter with number of columns"
# input_columns = gets.to_i
# puts "Enter with number of bombs"
# input_bombs = gets.to_i

m = Minesweep.new(5,5,4)
# m = Minesweep.new(input_rows,input_columns,input_bombs)

m.current_print()

loop do
  menu = "Menu:\
    \nc: Check cell\
    \nf: Set/Unset flag\
    \np: Print current state of field\
    \nx: Print x-ray field\
    \ne: Exit programn\n"
  puts menu
  print_mode = gets.chomp()
  puts
  case print_mode
  when "c"
    m.check_cell()
  when "f"
    m.set_flag()
  when "x"
    m.xray_print()
  when "p"
    m.current_print()
  end
  # if(print_mode == "x")
  #   xray_print()
  # elsif (print_mode == "p")
  #   current_print()
  # end
  break if print_mode == "e" || !m.still_playing?
  print_mode = "foo"
end

puts

puts "Game Over!"
if m.victory?
  puts "You win!"
else
  puts "You Lose!"
end
puts
  m.xray_print()
