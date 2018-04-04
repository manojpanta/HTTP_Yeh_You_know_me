require 'pry'
require './lib/server'
require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'

class ServerTest < MiniTest::Test
  def test_if_it_exists
    skip
    server = Server.new

    assert_instance_of Server, server
  end

  def test_response_body_includes_request_data_when_no_path_passed_in
    response = Faraday.get 'http://127.0.0.1:9292'

    expected = "<html><head></head><body><pre>Verb: GET\nPath: /\nProtocol:"\
               " HTTP/1.1\nHost:  127.0.0.1\nPort: \nOrigin:  127.0.0.1\n"\
               "Accept:  */*\n<pre></body></html>"

    assert_equal expected, response.body
  end

  def test_if_it_responds_according_to_path_passed_in
    response = Faraday.get('http://127.0.0.1:9292/hello')

    assert response.body.include?('Hello, World!')
  end

  def test_if_it_responds_according_to_path_passed_in_for_different_path
    response = Faraday.get('http://127.0.0.1:9292/datetime')

    assert response.body.include?('2018')
  end

  def test_for_shutdown_path
    skip
    response = Faraday.get('http://127.0.0.1:9292/shutdown')

    assert response.body.include?('Total Requests')
  end

  def test_if_header_shows_up_in_response
    response = Faraday.get('http://127.0.0.1:9292/datetime')

    assert_equal 'ruby', response.headers['server']
  end

  def test_passing_game_path_will_give_response_from_game_class
    response = Faraday.get('http://127.0.0.1:9292/game')
    param = 'guesses have been taken, most recent guess was'

    assert response.body.include?(param)
  end
end
