require 'spec_helper'

describe AuthenticationHash do
  let(:authentication_hash) { described_class.new }

  describe "#request_hash" do
    let(:parameters) { {
      appid: '157',
      uid: 'player1',
      ip: '212.45.111.17',
      locale: 'de',
      device_id: '2b6f0cc904d137be2e1730235f5664094b831186',
      ps_time: '1312211903',
      pub0: 'campaign2',
      page: '2',
      timestamp: '1312553361'
    } }

    it "generates request hash for key 'e95a21621a1865bcbae3bee89c4d4f84'" do
      authentication_hash.request_hash(parameters, 'e95a21621a1865bcbae3bee89c4d4f84')
                         .should eq '7a2b1604c03d46eec1ecd4a686787b75dd693c4d'
    end

    it "generates request hash for key '99999999999999999999999999999999'" do
      authentication_hash.request_hash(parameters, '99999999999999999999999999999999')
                         .should eq '823fee17e1d84aa7c7030b4489a72ab73df84d9e'
    end
  end
end

