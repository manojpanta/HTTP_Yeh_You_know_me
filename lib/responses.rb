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
    [ 'http/1.1 200 ok',
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                'server: ruby',
                'content-type: text/html; charset=iso-8859-1',
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end
end
