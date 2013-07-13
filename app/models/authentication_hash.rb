class AuthenticationHash
  def request_hash(parameters, api_key)
    hexdigest "#{parameters_text(parameters)}&#{api_key}"
  end

  def response_hash(body, api_key)
    hexdigest "#{body}#{api_key}"
  end

  private

  def hexdigest(text)
    Digest::SHA1.hexdigest text
  end

  def parameters_text(parameters)
    parameters.map{|k,v| "#{k}=#{v}"}.sort * '&'
  end
end
