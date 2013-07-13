class OffersApi < Sinatra::Base
  get "/offers.:format" do
    application = Application.where(external_id: params[:appid]).first
    halt 400, 'ERROR_INVALID_APPID' unless application

    safe_halt(application, 200) do
      offers = Offer.all
      if offers.any?
        presenter = OffersPresenter.new(offers)
        presenter.send("to_#{params[:format]}")
      else
        ''
      end
    end
  end

  private

  def safe_halt(application, code)
    authentication_hash = OffersSDK::AuthenticationHash.new(application.api_key)
    verify_request_hash! authentication_hash

    body = yield

    set_request_hash! authentication_hash, body

    halt code, body
  end

  def verify_request_hash!(authentication_hash)
    filtered_params = params.reject {|k,v| !['appid'].include? k}
    halt 401, 'ERROR_INVALID_HASHKEY' unless authentication_hash.valid_request?(filtered_params, params[:hash_key])
  end

  def set_request_hash!(authentication_hash, body)
    response['X-Sponsorpay-Response-Signature'] = authentication_hash.response_hash(body)
  end
end
