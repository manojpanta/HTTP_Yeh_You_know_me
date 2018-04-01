require 'socket'
class Server

  attr_reader :tcp_server, :client, :count

  def initialize
    @tcp_server = TCPServer.new(9292)
    @client = tcp_server.accept
    @request_lines = []
    @count = 0
  end

  def request
    @count += 1
    puts 'Ready for a request'
    while line = client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    puts 'Got this request:'
    puts @request_lines.inspect
  end

  def output
    puts 'Sending response.'
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ['http/1.1 200 ok',
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               'server: ruby',
               'content-type: text/html; charset=iso-8859-1',
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    puts ['Wrote this response:', headers, output].join("\n")
    puts "\nResponse complete, exiting."
  end

  def response
    if @request_lines.join.include?('hello')
      "Hello, World! (#{count})"
    elsif @request_lines.join.include?('datetime')
      Time.now.strftime('%I:%M %p on %A %B %W, %Y')
    elsif shutdown?
      stop_listening
    else
      '<pre>' "Verb: #{@request_lines[0][0..2]}\n"\
      "Path: #{@request_lines[0][4..-9]}\n"\
      "Protocol: #{@request_lines[0][-8..-1]}\n"\
      "Host: #{@request_lines[1][6..14]}\n"\
      "Port: #{@request_lines[1][-4..-1]}\n"\
      "Origin: #{@request_lines[1][6..14]}\n"\
      "Accept: #{@request_lines[6][8..-1]}\n"\
      'Hello World!! </pre>'
    end
  end

  def shutdown?
    @request_lines.join.include?('shutdown')
  end

  def stop_listening
    "Total Requests: #{count}"
  end
end
    server = Server.new
    server.request
    server.output
    # server.client.close
