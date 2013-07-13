class AuthenticationHash
  def request_hash(parameters, api_key)
    Digest::SHA1.hexdigest "#{parameters_text(parameters)}&#{api_key}"
  end

  private

  def parameters_text(parameters)
    parameters.map{|k,v| "#{k}=#{v}"}.sort * '&'
  end
end
