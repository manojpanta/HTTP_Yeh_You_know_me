require_relative 'test_helper'
require './lib/server'
require 'faraday'

class ServerTest < MiniTest::Test
  def test_response_body_includes_request_data_when_no_path_passed_in
    response = Faraday.get 'http://127.0.0.1:9292'

    expected = "<html><head></head><body><pre>Verb: GET\nPath: /\nProtocol:"\
               " HTTP/1.1\nHost:  127.0.0.1\nPort: \nOrigin:  127.0.0.1\n"\
               "Accept:  */*\n<pre></body></html>"
    assert_equal expected, response.body
  end

  def test_response_body_does_not_include_data_but_the_response_when_path_passed
    response = Faraday.get 'http://127.0.0.1:9292/hello'

    expected = response.body.include?('Hello, World!')

    assert expected, response
  end

  def test_if_it_responds_according_to_path_passed_in_for_different_path
    response = Faraday.get('http://127.0.0.1:9292/datetime')

    assert response.body.include?('on')
  end

  def test_if_header_shows_up_in_response_by_testing_server_which_lies_in_header
    response = Faraday.get('http://127.0.0.1:9292/datetime')

    assert_equal 'ruby', response.headers['server']
  end

  def test_it_responses_404_not_found_when_unknown_path_is_used
    response = Faraday.get('http://127.0.0.1:9292/hellothere')

    assert response.body.include?('404 not found!')
  end

  def test_it_server_responses_from_word_search_class_when_searching_known_word
    response = Faraday.get('http://127.0.0.1:9292/word_search?word=pizza')

    assert response.body.include?('pizza is a known word,')
  end

  def test_it_server_responses_from_word_search_class_when_searching_unknownword
    response = Faraday.get('http://127.0.0.1:9292/word_search?word=xcvn')

    assert response.body.include?('xcvn is not a known word,')
  end
end
