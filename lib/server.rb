require 'socket'
require_relative 'responses'
require_relative 'parser'
require_relative 'word_search'
require_relative 'game'
class Server
  include Response
  include Parser

  attr_reader :tcp_server,
              :count,
              :request_lines,
              :client

  def initialize
    @tcp_server = TCPServer.new(9292)
    @request_lines = []
    @client = tcp_server.accept
    @count = 0
    @word_search = WordSearch.new
    @game = Game.new
  end

  def request
    @count += 1
    while line = client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    puts 'Got this request:'
    puts @request_lines.inspect
  end

  def response
    if path == "Path: /hello\n"
      respond_to_hello(count)

    elsif path == "Path: /datetime\n"
      respond_to_datetime

    elsif path == "Path: /shutdown\n"
      stop_listening(count)

    elsif path == "Path: /game\n" and verb == "Verb: GET\n"
      @game.response

    elsif path.include?('start_game') && verb == "Verb: POST\n"
      'Good Luck!'

    elsif path == "Path: /game\n" and verb == "Verb: POST\n"
      guess =  @client.read(content_length).split("=")[1]
      @game.take_guesses(guess)

    elsif path.include?('word_search?')
      word = path.split[1].split('?')[1].split('=')[1]
      @word_search.feedback(word)

    else
      '<pre>' + verb + path + protocol + host + port + origin + accept + '<pre>'
    end
  end

  def output
    puts 'Sending response.'
    output = "<html><head></head><body>#{response}</body></html>"
    headers = headers(output)
    client.puts headers
    client.puts output
    puts ['Wrote this response:', headers, output].join("\n")
  end

  def start
    loop do
      request
      output
      if shutdown?
        puts "\nResponse complete, exiting."
        return tcp_server.close
      else
        puts 'Ready for a request'
        @client = tcp_server.accept
        @request_lines = []
      end
    end
  end

  def shutdown?
    path == "Path: /shutdown\n"
  end
end
