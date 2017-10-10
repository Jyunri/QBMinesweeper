require './iohandler.rb'
require './printers.rb'
require 'pry'

include IOHandler

g = IOHandler.new_game_input
print_style = 1
printer = SimplePrinter.new
printer.print_state(g.board_state)
loop do
  IOHandler.menu
  puts print_mode = gets.chomp
  case print_mode
  when 'c'
    g.game_check_cell
  when 'f'
    g.game_set_flag
  when 'x'
    puts printer.print_state(g.board_state(xray: true))
  when 's'
    IOHandler.save_game(g.board_state2)
  when 'l'
    IOHandler.load_game(g, 'savefile.json')
  when 'p'
    if print_style == 1
      printer = PrettyPrinter.new
      print_style = 2
    else
      printer = SimplePrinter.new
      print_style = 1
    end
  end
  break if print_mode == 'e' || !g.still_playing?
  puts printer.print_state(g.board_state)
end

puts

puts 'Game Over!'
if g.victory?
  puts 'You win!'
else
  puts 'You Lose!'
end

puts printer.print_state(g.board_state(xray: true))
