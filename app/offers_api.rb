class OffersApi < Sinatra::Base
  get "/offers" do
    application = Application.where(external_id: params[:appid]).first

    safe_halt(application) do |body|
      body = ''
    end
  end

  private

  def safe_halt(application, &block)
    authentication_hash = AuthenticationHash.new(application.api_key)
    verify_request_hash! authentication_hash, params[:hash_key]

    block.call(body = '')

    set_request_hash! authentication_hash, body

    halt 200, body
  end

  def verify_request_hash!(authentication_hash, hash_key)
    halt 401, 'ERROR_INVALID_HASHKEY' unless authentication_hash.valid_request?(params, hash_key)
  end

  def set_request_hash!(authentication_hash, body)
    response['X-Sponsorpay-Response-Signature'] = authentication_hash.response_hash(body)
  end
end
