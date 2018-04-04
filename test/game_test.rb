require './lib/game'
require 'minitest/autorun'
require 'minitest/pride'

class GameTest < MiniTest::Test
  def test_if_it_exists
    game = Game.new
    assert_instance_of Game, game
  end

  def test_it_can_create_a_random_number_between_one_and_hundred
    game = Game.new

    assert ('1'..'100').to_a.include?(game.answer)
  end

  def test_there_are_no_guesses_initially
    game = Game.new
    assert game.guesses.empty?
  end

  def test_it_can_take_guesses
    game = Game.new(12)

    assert_equal 'too high', game.take_guesses(15)
  end

  def test_guesses_array_increases_as_we_guess
    game = Game.new

    game.take_guesses(12)
    game.take_guesses(12)
    game.take_guesses(12)

    assert_equal 3, game.guesses.length
  end

  def test_it_can_give_feedback
    game = Game.new(12)

    assert_equal 'too low', game.take_guesses(5)
  end

  def test_it_can_show_the_last_guess
    game = Game.new(23)
    game.take_guesses(12)
    game.take_guesses(12)
    game.take_guesses(15)
    result = '3 guesses have been taken, most recent guess was'\
            ' 15 and it was too low'
    assert_equal result, game.response
  end
end
