# Usage of engine described in email
# alternative for cli_app.rb
require './minesweeper.rb'
require './printers.rb'

width, height, num_mines = 10, 17, 50
game = Minesweeper.new(width, height, num_mines)

while game.still_playing?
  valid_move = game.game_check_cell(rand(width), rand(height))
  valid_flag = game.game_set_flag(rand(width), rand(height))
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
