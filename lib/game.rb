class Game
  attr_reader :guesses,
              :answer

  def initialize(answer = (1..100).to_a.sample(1).join)
    @guesses = []
    @answer = answer
    @count = 0
  end

  def take_guesses(guess)
    @count += 1
    @guesses << guess
    feedback(guess)
  end

  def response
    "#{@guesses.length} guesses have been taken, most recent guess was"\
    " #{@guesses.last} and it was #{feedback(@guesses.last)}"
  end

  def feedback(guess)
    if guess == answer
      'correct!'
    elsif guess.to_i > answer.to_i
      'too high'
    elsif guess.to_i < answer.to_i
      'too low'
    end
  end
end
