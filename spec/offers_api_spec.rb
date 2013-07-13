require 'spec_helper'

describe OffersApi do
  let(:app) { described_class }

  describe "offers with GET" do
    let!(:application) { Application.create! api_key: 'e95a21621a1865bcbae3bee89c4d4f84', external_id: '123' }

    context "when authentication hash is invalid" do
      it "returns status code 401" do
        get '/offers.json', hash_key: 'invalid_hash_key', appid: '123'
        last_response.status.should eq 401
      end

      it "returns body ERROR_INVALID_HASHKEY" do
        get '/offers.json', hash_key: 'invalid_hash_key', appid: '123'
        last_response.body.should eq 'ERROR_INVALID_HASHKEY'
      end
    end

    context "when app id is invalid" do
      it "returns status code 400" do
        get '/offers.json', hash_key: 'hash_key', appid: '456'
        last_response.status.should eq 400
      end

      it "returns body ERROR_INVALID_APPID" do
        get '/offers.json', hash_key: 'hash_key', appid: '456'
        last_response.body.should eq 'ERROR_INVALID_APPID'
      end
    end

    context "when authentication hash is valid" do
      let(:valid_hash_key) { '7a2b1604c03d46eec1ecd4a686787b75dd693c4d' }

      before do
        auth_hash = OffersSDK::AuthenticationHash.new(application.api_key)
        auth_hash.stub(:valid_request?).with(anything, valid_hash_key).and_return(true)
        OffersSDK::AuthenticationHash.stub(:new).with(application.api_key).and_return(auth_hash)
      end

      it "returns status code 200" do
        get '/offers.json', hash_key: valid_hash_key, appid: '123'
        last_response.status.should eq 200
      end

      context "filtering params" do
        let!(:auth_hash) { OffersSDK::AuthenticationHash.new(application.api_key) }

        before do
          OffersSDK::AuthenticationHash.unstub(:new)
          OffersSDK::AuthenticationHash.stub(:new).with(application.api_key).and_return(auth_hash)
        end

        it "filters params before checks the hash_key" do
          expected_hash = {"appid"=>"123", "pub0"=>"campaign", "uid"=>"123", "page"=>"2", "ip"=>"192.168.0.1", "offer_types"=>"123", "locale"=>"de", "device_id"=>"123"}
          auth_hash.should_receive(:valid_request?).with(expected_hash, valid_hash_key).and_return(true)
          get '/offers.json', hash_key: valid_hash_key, appid: '123', unknown_param: 'aaa', pub0: 'campaign', uid: '123', page: '2', ip: '192.168.0.1', offer_types: '123', locale: 'de', device_id: '123'
        end
      end

      it "returns X-Sponsorpay-Response-Signature header" do
        get '/offers.json', hash_key: valid_hash_key, appid: '123'
        last_response.headers['X-Sponsorpay-Response-Signature'].should eq "a3dcf2c6e2335f93b4aca162349373d783a2bab5"
      end

      it "returns an empty response body if there aren't offers" do
        get '/offers.json', hash_key: valid_hash_key, appid: '123'
        last_response.body.should be_empty
      end

      it "returns offers as json when content type is json" do
        create :offer
        get '/offers.json', hash_key: valid_hash_key, appid: '123'
        response = JSON.parse(last_response.body)
        response['offers'].should have(1).item
      end

      it "returns offers as xml when content type is xml" do
        create :offer
        get '/offers.xml', hash_key: valid_hash_key, appid: '123'
        response = Hash.from_xml(last_response.body)
        response['response']['offers'].should have(1).item
      end
    end
  end
end

