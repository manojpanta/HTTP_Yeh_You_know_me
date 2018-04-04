require 'pry'
require './lib/word_search'
require 'minitest/autorun'
require 'minitest/pride'

class WordSearchTest< Minitest::Test

  def test_if_it_exists
    wordsearch = WordSearch.new

    assert_instance_of WordSearch, wordsearch
  end

  def test_dictionary_file_is_accessible
    wordsearch = WordSearch.new

    assert_equal true, wordsearch.file.include?('A')
  end

  def test_known_method_works_for_aknown_word
    wordsearch = WordSearch.new

    assert wordsearch.known?('A')
  end

  def test_known_method_works_for_unknown_word
    wordsearch = WordSearch.new

    refute wordsearch.known?('Manoj')
  end

  def test_feedback_works_for_known_word
    wordsearch = WordSearch.new

    assert_equal 'A is a known word', wordsearch.feedback('A')
  end

  def test_feedback_works_for_unknown_word
    wordsearch = WordSearch.new

    assert_equal 'Manoj is not a known word', wordsearch.feedback('Manoj')
  end
end
