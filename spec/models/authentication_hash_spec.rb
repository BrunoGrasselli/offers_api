require 'spec_helper'

describe AuthenticationHash do
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
      described_class.new('e95a21621a1865bcbae3bee89c4d4f84')
                     .request_hash(parameters)
                     .should eq '7a2b1604c03d46eec1ecd4a686787b75dd693c4d'
    end

    it "generates request hash for key '99999999999999999999999999999999'" do
      described_class.new('99999999999999999999999999999999')
                     .request_hash(parameters)
                     .should eq '823fee17e1d84aa7c7030b4489a72ab73df84d9e'
    end
  end

  describe "#response_hash" do
    it "generates response hash for key 'e95a21621a1865bcbae3bee89c4d4f84'" do
      described_class.new('e95a21621a1865bcbae3bee89c4d4f84')
                     .response_hash('body message')
                     .should eq 'ede88b1b612ec07f1282f6dd69f09b53a1a904e3'
    end

    it "generates response hash for key '99999999999999999999999999999999'" do
      described_class.new('99999999999999999999999999999999')
                     .response_hash('another message')
                     .should eq 'c2e20d6bec2b4865ff1be5bf2b52cc8524951adf'
    end
  end
end

