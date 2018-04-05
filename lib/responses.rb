module Response
  def respond_to_hello
    @hello_count += 1
    "Hello, World! (#{@hello_count})"
  end

  def respond_to_datetime
    Time.now.strftime('%l:%M %p on %A, %B %d, %C%y')
  end

  def stop_listening(count)
    "Total Requests: #{count}"
  end

  def headers(output)
    ['http/1.1 200 ok',
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     'server: ruby',
     'content-type: text/html; charset=iso-8859-1',
     "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def redirect_headers(status_code, new_location)
    ["http/1.1 #{status_code}",
     "Location: #{new_location}",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     'server: ruby',
     'content-type: text/html; charset=iso-8859-1'].join("\r\n")
  end

  def output
    puts 'Sending response.'
    output = "<html><head></head><body>#{response}</body></html>"
    headers = headers(output)
    client.puts headers
    client.puts output
    puts ['Wrote this response:', headers, output].join("\n")
  end

  def response
    if path == '/hello'
      respond_to_hello

    elsif path == '/datetime'
      respond_to_datetime

    elsif path == '/shutdown'
      stop_listening(count)

    elsif path == '/force_error'
      raise SystemError

    elsif !valid_paths.include?(path) && !path.include?('word_search?')
      '404 not found'

    elsif path == '/game' and verb == 'GET'
      @game.game_response

    elsif path == '/start_game' && verb == 'POST'
      @game = Game.new
      headers = redirect_headers('301 Moved Permanently',
                                 'http://127.0.0.1:9292/game')
      client.puts headers

    elsif path == '/game' and verb == 'POST'
      guess =  @client.read(content_length).split('=')[1]
      @game.take_guesses(guess)
      headers = redirect_headers('302 Found', 'http://127.0.0.1:9292/game')
      client.puts headers

    elsif path.include?('word_search?')
      word1 = path.split('=')[1].split('&')[0]
      word2 = path.split('=')[2]
      "#{@word_search.feedback(word1)}, #{@word_search.feedback(word2)}"
    else
      '<pre>' + "Verb: #{verb}\n" + "Path: #{path}\n" + "Protocol: #{protocol}\n" + "Host: #{host}\n" + "Port: #{port}\n" + "Origin: #{origin}\n" + "Accept: #{accept}\n" + '<pre>'
    end
  end

  def valid_paths
    ['/hello', '/datetime', '/shutdown', '/force_error', '/game', '/start_game']
  end
end
