require 'socket'
require_relative 'responses'
require_relative 'word_search'
class Server
  include Response

  attr_reader :tcp_server,
              :client,
              :count

  def initialize
    @tcp_server = TCPServer.new(9292)
    @client = tcp_server.accept
    @request_lines = []
    @count = 0
    @word_search = WordSearch.new
  end

  def request
    while line = client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    puts 'Got this request:'
    puts @request_lines.inspect
  end


  def response
    @count += 1
    if path == "Path: /hello\n"
      response_to_hello(count)
    elsif path == "Path: /datetime\n"
      datetime
    elsif path == "Path: /shutdown\n"
      stop_listening(count)
    elsif path.include?("word_search?")
      word = path.split[1].split("?")[1].split("=")[1]
      @word_search.feedback(word)
    else
      '<pre>' + verb + path + protocol + host + port + origin + accept + '<pre>'
    end
  end

  def output
    puts 'Sending response.'
    output = "<html><head></head><body>#{response}</body></html>"
    headers = [ 'http/1.1 200 ok',
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                'server: ruby',
                'content-type: text/html; charset=iso-8859-1',
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    puts ['Wrote this response:', headers, output].join("\n")
    if path == "Path: /shutdown\n"
      client.close
      puts "\nResponse complete, exiting."
      abort
    end
  end

  def start
    loop do
      request
      output
      puts 'Ready for a request'
      @client = tcp_server.accept
      @request_lines = []
    end
  end
end
