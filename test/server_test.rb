require 'pry'
require './lib/server'
require 'minitest/autorun'
require 'minitest/pride'


class ServerTest < MiniTest::Test
  def test_if_postman_gets_right_one
    server = Server.new
    response = Postman.get('http://127.0.0.1:9292')
    expected = ".. "
    assert_equal expected, response
  end





end
