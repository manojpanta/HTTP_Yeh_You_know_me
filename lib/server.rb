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
  end

  def request
    @count += 1
    while line = client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    puts 'Got this request:'
    puts @request_lines.inspect
  end


  def shutdown?
    path == '/shutdown'
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
end
