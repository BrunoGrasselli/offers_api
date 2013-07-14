class OffersApi < Sinatra::Base
  get "/offers.:format" do
    application = Application.where(external_id: params[:appid]).first
    halt 400, 'ERROR_INVALID_APPID' unless application

    safe_halt(application, 200) do
      offers = Offer.by_types(params[:offer_types]).paginate(per_page: per_page, page: page)

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
    auth_hash = OffersSDK::AuthenticationHash.new(application.api_key)
    verify_request_hash! auth_hash

    body = yield

    set_request_hash! auth_hash, body

    halt code, body
  end

  def verify_request_hash!(auth_hash)
    filtered_params = params.reject {|k,v| !['appid', 'uid', 'pub0', 'page', 'device_id', 'locale', 'ip', 'offer_types'].include? k}
    halt 401, 'ERROR_INVALID_HASHKEY' unless auth_hash.valid_request?(filtered_params, params[:hash_key])
  end

  def set_request_hash!(auth_hash, body)
    response['X-Sponsorpay-Response-Signature'] = auth_hash.response_hash(body)
  end

  def page
    params[:page].to_i == 0 ? 1 : params[:page]
  end

  def per_page
    Offer.per_page
  end
end
