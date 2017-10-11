
# Printer class. Uses the custom Minesweep and Cell objects from this project.
# It's straightfoward but it requires to recognize the custom classes
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


### Example usage of engine
width, height, num_mines = 5, 5, 5
game = Minesweeper.new(width, height, num_mines)

while game.still_playing?
  valid_move = game.game_check_cell
  valid_flag = game.game_set_flag
  if valid_move or valid_flag
  printer = (rand > 0.5) ? SimplePrinter.new : PrettyPrinter.new
  printer.print_state(game.board_state)
  end
end

puts "Fim do jogo!"
if game.victory?
  puts "Você venceu!"
else
  puts "Você perdeu! As minas eram:"
  PrettyPrinter.new.print_state(game.board_state(xray: true))
end

###

<td><textarea readonly height="3" style="align-content:center;"><%= $m.clear_cell_count%></textarea></td>

###

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