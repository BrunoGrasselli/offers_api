require 'spec_helper'

describe OffersApi do
  let(:app) { described_class }

  describe "offers with GET" do
    it "returns status code 200" do
      get '/offers'
      last_response.status.should eq 200
    end
  end
end

