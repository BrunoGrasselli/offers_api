class OffersApi < Sinatra::Base
  get "/offers" do
    application = Application.where(external_id: params[:appid]).first

    verify_auth_hash! application, params[:hash_key]

    status 200
  end

  private

  def verify_auth_hash!(application, hash_key)
    authentication_hash = AuthenticationHash.new(application.api_key)
    halt 401, 'ERROR_INVALID_HASHKEY' unless authentication_hash.valid_request?(params, hash_key)
  end
end
