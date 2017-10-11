require 'minitest/autorun'
require_relative 'minesweeper'
require './iohandler.rb'
require 'pry'

# dummy class to include module in tests
class ModuleClass
  include IOHandler
end

# Unit Test Class to validate Game instance from a load file
# and from random instances
class MinesweeperTest < Minitest::Test
  def setup
    @m = Minesweeper.new(10, 20, 10)
    module_class = ModuleClass.new
    module_class.load_game(@m, 'testfile.json')
  end

  def test_initialize
    assert_equal(8, @m.row)
    assert_equal(7, @m.col)
    assert_equal(11, @m.bombs_count)
  end

  def test_special_properties
    assert_equal(7, @m.flag_count)
    assert_equal(45, @m.clear_cell_count)
  end

  def test_negative_rows
    assert_raises ArgumentError do
      Minesweeper.new(-10, 10, 10)
    end
  end

  def test_negative_columns
    assert_raises ArgumentError do
      Minesweeper.new(10, -10, 10)
    end
  end

  def test_negative_bombs
    assert_raises ArgumentError do
      Minesweeper.new(10, 10, -10)
    end
  end

  def test_instant_win
    @m.clear_cell_count = 0
    assert @m.victory? == true
  end

  def test_check_valid_cell
    assert_output("Nice! There's still 44 clear cells left!\n") do
      @m.game_check_cell(2, 2)
    end
  end

  def test_check_expansion
    @m.game_check_cell(1, 2)
    assert_equal(29, @m.clear_cell_count)
  end

  def test_check_invalid_cell
    assert_output("Invalid position!\n") do
      @m.game_check_cell(100, 100)
    end
  end

  def test_flag_invalid_cell
    assert_output("Invalid position!\n") do
      @m.game_set_flag(100, 100)
    end
  end

  def test_check_flagged_cell
    assert_output("Invalid position!\n") do
      @m.game_check_cell(1, 1)
    end
  end

  def test_unflag_cell
    assert_output("Flag unset from position (1,1)\n") do
      @m.game_set_flag(1, 1)
    end
  end

  def test_check_bomb
    @m.game_check_cell(1, 4)
    assert @m.game_over == true
  end
end
