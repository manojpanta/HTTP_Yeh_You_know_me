module Parser
  def verb
    "#{@request_lines[0].split[0]}"
  end

  def path
    "#{@request_lines[0].split[1]}"
  end

  def protocol
    "#{@request_lines[0].split[2]}"
  end

  def parse
    hash = {}
    @request_lines.each do |string|
      hash[string.split(':')[0]] = string.split(':')[1]
    end
    hash
  end

  def host
    "#{parse['Host']}"
  end

  def port
    "#{@request_lines[1].split[1].split(':')[1]}"
  end

  def origin
    "#{parse['Host']}"
  end

  def accept
    "#{parse['Accept']}"
  end

  def content_length
    parse['Content-Length'].to_i
  end
end
