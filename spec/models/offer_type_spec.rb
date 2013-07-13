require 'spec_helper'

describe OfferType do
  let(:offer_type) { described_class.new }

  it "validates presence of external_id" do
    offer_type.external_id = nil
    offer_type.valid?
    offer_type.errors[:external_id].should_not be_empty
  end

  describe "#readable" do
    it "returns information based on the READABLE_MAP" do
      offer_type.external_id = 100
      offer_type.readable.should eq 'Mobile'

      offer_type.external_id = 106
      offer_type.readable.should eq 'Games'

      offer_type.external_id = 112
      offer_type.readable.should eq 'Free'
    end
  end
end

