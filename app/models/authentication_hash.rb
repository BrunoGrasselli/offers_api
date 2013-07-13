class AuthenticationHash
  def initialize(api_key)
    @api_key = api_key
  end

  def request_hash(parameters)
    hexdigest "#{parameters_text(parameters)}&#{api_key}"
  end

  def response_hash(body)
    hexdigest "#{body}#{api_key}"
  end

  private

  def api_key
    @api_key
  end

  def hexdigest(text)
    Digest::SHA1.hexdigest text
  end

  def parameters_text(parameters)
    parameters.map{|k,v| "#{k}=#{v}"}.sort * '&'
  end
end
