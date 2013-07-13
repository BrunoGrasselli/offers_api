require 'spec_helper'

describe OffersApi do
  let(:app) { described_class }

  describe "offers with GET" do
    let(:user_api_key) { 'e95a21621a1865bcbae3bee89c4d4f84' }

    context "when authentication hash is invalid" do
      let(:invalid_hash_key) { 'invalid_hash' }

      it "returns status code 401" do
        get '/offers', hash_key: invalid_hash_key
        last_response.status.should eq 401
      end

      it "returns body ERROR_INVALID_HASHKEY" do
        get '/offers', hash_key: invalid_hash_key
        last_response.body.should eq 'ERROR_INVALID_HASHKEY'
      end
    end

    context "when authentication hash is valid" do
      let(:valid_hash_key) { '7a2b1604c03d46eec1ecd4a686787b75dd693c4d' }

      it "returns status code 200" do
        get '/offers', hash_key: valid_hash_key
        last_response.status.should eq 200
      end
    end
  end
end

