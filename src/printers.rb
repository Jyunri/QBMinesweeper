# Parse string status and type to visual representation
module CellToString
  def cell_type_print(cell)
    cell_type = cell[:type]
    if cell_type.zero?
      cell[:bombs_count].to_s
    elsif cell_type == 1
      '#'
    end
  end

  def cell_status_print(cell)
    if cell[:status] == 1
      cell_type_print(cell).to_s
    elsif cell[:status].zero?
      '?'
    elsif cell[:status] == 2
      'F'
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
        print "#{cell_type_print(cell)}\t"
      end
      puts
    end
  end

  def current_state_print
    puts 'Current print:'
    (0..@board_state[:row_count] + 1).each do |i|
      (0..@board_state[:col_count] + 1).each do |j|
        cell = @board_state[:field][i, j]
        print "#{cell_status_print(cell)}\t"
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
        print "#{cell_type_print(cell)}\t"
      end
      puts
    end
  end

  def current_state_print
    puts 'Current print:'
    (0..@board_state[:row_count] + 1).each do |i|
      (0..@board_state[:col_count] + 1).each do |j|
        cell = @board_state[:field][i, j]
        print "#{cell_status_print(cell)}\t"
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
