require 'spec_helper'

describe OffersApi do
  let(:app) { described_class }

  describe "offers with GET" do
    let!(:application) { Application.create! api_key: 'e95a21621a1865bcbae3bee89c4d4f84', external_id: '123' }

    context "when authentication hash is invalid" do
      it "returns status code 401" do
        get '/offers', hash_key: 'invalid_hash_key', appid: '123'
        last_response.status.should eq 401
      end

      it "returns body ERROR_INVALID_HASHKEY" do
        get '/offers', hash_key: 'invalid_hash_key', appid: '123'
        last_response.body.should eq 'ERROR_INVALID_HASHKEY'
      end
    end

    context "when authentication hash is valid" do
      let(:valid_hash_key) { '7a2b1604c03d46eec1ecd4a686787b75dd693c4d' }

      before do
        authentication_hash = AuthenticationHash.new(application.api_key)
        authentication_hash.stub(:valid_request?).with(anything, valid_hash_key).and_return(true)
        AuthenticationHash.stub(:new).with(application.api_key).and_return(authentication_hash)
      end

      it "returns status code 200" do
        get '/offers', hash_key: valid_hash_key, appid: '123'
        last_response.status.should eq 200
      end

      it "filters params before checks the hash_key" do
        AuthenticationHash.unstub(:new)
        authentication_hash = AuthenticationHash.new(application.api_key)
        authentication_hash.stub(:valid_request?).with({'appid' => '123'}, valid_hash_key).and_return(true)
        AuthenticationHash.stub(:new).with(application.api_key).and_return(authentication_hash)
        get '/offers', hash_key: valid_hash_key, appid: '123'
      end

      it "returns X-Sponsorpay-Response-Signature header" do
        get '/offers', hash_key: valid_hash_key, appid: '123'
        last_response.headers['X-Sponsorpay-Response-Signature'].should eq "a3dcf2c6e2335f93b4aca162349373d783a2bab5"
      end
    end
  end
end

