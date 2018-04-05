require_relative 'test_helper'
require './lib/game'

class GameTest < MiniTest::Test
  def test_if_it_exists
    game = Game.new
    assert_instance_of Game, game
  end

  def test_it_can_create_a_random_number_between_one_and_hundred
    game = Game.new

    assert ('1'..'100').to_a.include?(game.answer.to_s)
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

  def test_it_can_give_feedback_too_low
    game = Game.new(12)

    assert_equal 'too low', game.take_guesses(5)
  end

  def test_it_can_give_feedback_too_high
    game = Game.new(12)

    assert_equal 'too high', game.take_guesses(15)
  end

  def test_it_can_give_feedback_correct
    game = Game.new(12)

    assert_equal 'correct!', game.take_guesses(12)
  end

  def test_it_says_goodluck_if_no_guesses_taken
    game = Game.new(12)
    assert_equal 'Good Luck!', game.game_response
  end

  def test_it_gives_us_game_diagnostics_if_guesses_taken
    game = Game.new(12)

    game.take_guesses(2)

    result = '1 guesses have been taken, most recent'\
             ' guess was 2 and it was too low'

    assert_equal result, game.game_response
  end

  def test_it_can_show_the_last_guess
    game = Game.new(23)

    game.take_guesses(12)
    game.take_guesses(12)
    game.take_guesses(15)

    result = '3 guesses have been taken, most recent guess was'\
            ' 15 and it was too low'

    assert_equal result, game.game_response
  end
end
