module Response

  def response_to_hello(count)
    "Hello, World! (#{count})"
  end

  def datetime
    Time.now.strftime('%l:%M %p on %A, %B %d, %C%y')
  end

  def verb
    "Verb: #{@request_lines[0].split[0]}\n"
  end

  def path
    "Path: #{@request_lines[0].split[1]}\n"
  end

  def protocol
    "Protocol: #{@request_lines[0].split[2]}\n"
  end

  def host
    "Host: #{@request_lines[1].split[1].split(":")[0]}\n"
  end

  def port
    "Port: #{@request_lines[1].split[1].split(":")[1]}\n"
  end

  def origin
    "Origin: #{@request_lines[1].split[1].split(":")[0]}\n"
  end

  def accept
    "Accept: #{@request_lines[6].split[1]}\n"
  end

  def stop_listening(count)
    "Total Requests: #{count}"
  end
end
