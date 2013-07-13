class OffersApi < Sinatra::Base
  get "/offers" do
    application = Application.where(external_id: params[:appid]).first

    safe_halt(application, 200) do |body|
      body = ''
    end
  end

  private

  def safe_halt(application, code, &block)
    authentication_hash = AuthenticationHash.new(application.api_key)
    verify_request_hash! authentication_hash

    block.call(body = '')

    set_request_hash! authentication_hash, body

    halt code, body
  end

  def verify_request_hash!(authentication_hash)
    filtered_params = params.except('hash_key')
    halt 401, 'ERROR_INVALID_HASHKEY' unless authentication_hash.valid_request?(filtered_params, params[:hash_key])
  end

  def set_request_hash!(authentication_hash, body)
    response['X-Sponsorpay-Response-Signature'] = authentication_hash.response_hash(body)
  end
end
