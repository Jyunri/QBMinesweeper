require 'colorize'

# Parse string status and type to visual representation.
# print_mode can be 0 (simple) or 1 (pretty)
module CellToString
  def cell_type_print(cell, print_mode)
    bomb_cell = ['#', "\u{1F4A3}"]
    cell_type = cell[:type]
    if cell_type.zero?
      cell[:bombs_count].to_s
    elsif cell_type == 1
      bomb_cell[print_mode]
    end
  end

  def cell_status_print(cell, print_mode)
    flag_cell = ['F', "\u{1F3F3}".bold.colorize(:red)]
    clear_cell = ['?', "\u{1F381}".bold.colorize(:yellow)]
    if cell[:status] == 1
      cell_type_print(cell, print_mode).to_s
    elsif cell[:status].zero?
      clear_cell[print_mode]
    elsif cell[:status] == 2
      flag_cell[print_mode]
    end
  end
end

# Simple printer class. Uses Matrix and Hashes representation from board_state,
# hence it can be used to print the board without knowing the custom classes
class SimplePrinter
  include CellToString
  attr_accessor :board_state

  def xray_print
    puts 'X-ray field:'
    (0..@board_state[:row_count] + 1).each do |i|
      (0..@board_state[:col_count] + 1).each do |j|
        cell = @board_state[:field][i, j]
        print "#{cell_type_print(cell, 0)}\t"
      end
      puts
    end
  end

  def current_state_print
    puts 'Current print:'
    (0..@board_state[:row_count] + 1).each do |i|
      (0..@board_state[:col_count] + 1).each do |j|
        cell = @board_state[:field][i, j]
        print "#{cell_status_print(cell, 0)}\t"
      end
      puts
    end
  end

  def print_state(board_state)
    @board_state = board_state
    hidden = @board_state[:hidden]

    if hidden
      xray_print
    else
      current_state_print
    end

    puts
  end
end

# Simple printer class. Uses Matrix and Hashes representation from board_state,
# hence it can be used to print the board without knowing the custom classes
class PrettyPrinter
  include CellToString
  attr_accessor :board_state

  def xray_print
    puts 'X-ray field:'
    (0..@board_state[:row_count] + 1).each do |i|
      (0..@board_state[:col_count] + 1).each do |j|
        cell = @board_state[:field][i, j]
        print "#{cell_type_print(cell, 1)}\t"
      end
      puts
    end
  end

  def current_state_print
    puts 'Current print:'
    (0..@board_state[:row_count] + 1).each do |i|
      (0..@board_state[:col_count] + 1).each do |j|
        cell = @board_state[:field][i, j]
        print "#{cell_status_print(cell, 1)}\t"
      end
      puts
    end
  end

  def print_state(board_state)
    @board_state = board_state
    hidden = @board_state[:hidden]

    if hidden
      xray_print
    else
      current_state_print
    end

    puts
  end
end
