require 'matrix'

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
      expand_neighborhood(game) if bombs_in_neighborhood.zero?
      puts "Nice! There's still #{game.clear_cell_count} clear cells left!"
    else
      puts 'Invalid position!'
    end
  end

  def expand_neighborhood(game)
    (row - 1..row + 1).each do |r|
      (col - 1..col + 1).each do |c|
        next if r == row && c == col
        cell = game.mine_field[r, c]
        next unless cell.unchecked?
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
