class WordSearch
  include Response

  attr_reader :file

  def initialize
    @file = File.read('/usr/share/dict/words')
  end

  def known?(word)
    file.split("\n").include?(word)
  end

  def feedback(word)
    if known?(word)
      "#{word} is a known word"
    elsif word.nil?
      nil
    else
      "#{word} is not a known word"
    end
  end
end
