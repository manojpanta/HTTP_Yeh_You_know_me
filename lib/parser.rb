module Parser
  def verb
    "Verb: #{@request_lines[0].split[0]}\n"
  end

  def path
    "Path: #{@request_lines[0].split[1]}\n"
  end

  def protocol
    "Protocol: #{@request_lines[0].split[2]}\n"
  end

  def parse
    hash = {}
    @request_lines.each do |string|
      hash[string.split(':')[0]] = string.split(':')[1]
    end
    hash
  end

  def host
    "Host: #{parse['Host']}\n"
  end

  def port
    "Port: #{@request_lines[1].split[1].split(':')[1]}\n"
  end

  def origin
    "Origin: #{parse['Host']}\n"
  end

  def accept
    "Accept: #{parse['Accept']}\n"
  end

  def content_length
    parse['Content-Length'].to_i
  end
end
