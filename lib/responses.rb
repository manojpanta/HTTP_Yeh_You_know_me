module Response
  def respond_to_hello(count)
    "Hello, World! (#{count})"
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

  def output
    puts 'Sending response.'
    output = "<html><head></head><body>#{response}</body></html>"
    headers = headers(output)
    client.puts headers
    client.puts output
    puts ['Wrote this response:', headers, output].join("\n")
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
      guess =  @client.read(content_length).split('=')[1]
      @game.take_guesses(guess)

    elsif path.include?('word_search?')
      word = path.split[1].split('?')[1].split('=')[1]
      @word_search.feedback(word)

    else
      '<pre>' + verb + path + protocol + host + port + origin + accept + '<pre>'
    end
  end
end
