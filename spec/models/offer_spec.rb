require 'spec_helper'

describe Offer do
  let(:offer) { described_class.new }

  it "validates presence of title" do
    offer.title = nil
    offer.valid?
    offer.errors[:title].should_not be_empty
  end

  it "validates presence of link" do
    offer.link = nil
    offer.valid?
    offer.errors[:link].should_not be_empty
  end

  it "validates presence of payout" do
    offer.payout = nil
    offer.valid?
    offer.errors[:payout].should_not be_empty
  end

  it "validates presence of required_action" do
    offer.required_action = nil
    offer.valid?
    offer.errors[:required_action].should_not be_empty
  end

  it "has default value for thumbnail field" do
    offer.thumbnail.should eq({})
  end

  it "embeds offer types" do
    offer.offer_types.build external_id: 100
    offer.offer_types.first.readable.should eq 'Mobile'
  end

  describe "#teaser" do
    it "returns description when it is present" do
      offer.attributes = {description: 'some description', required_action: 'an action'}
      offer.teaser.should eq 'some description'
    end

    it "returns required action when description is missing" do
      offer.attributes = {description: '', required_action: 'an action'}
      offer.teaser.should eq 'an action'

      offer.attributes = {description: nil, required_action: 'an action'}
      offer.teaser.should eq 'an action'
    end
  end

  describe ".by_types" do
    let!(:offer_1) { create(:offer, offer_types: [OfferType.new(external_id:  100)]) }
    let!(:offer_2) { create(:offer, offer_types: [OfferType.new(external_id:  100)]) }
    let!(:offer_3) { create(:offer, offer_types: [OfferType.new(external_id:  102)]) }
    let!(:offer_4) { create(:offer, offer_types: []) }

    it "filters by one offer type" do
      described_class.by_types('100').to_a.should eq [offer_1, offer_2]
    end

    it "filters by more than one offer types" do
      described_class.by_types('100,102').to_a.should eq [offer_1, offer_2, offer_3]
    end

    it "returns all offers if no type was given" do
      described_class.by_types('').to_a.should eq [offer_1, offer_2, offer_3, offer_4]
      described_class.by_types(nil).to_a.should eq [offer_1, offer_2, offer_3, offer_4]
    end
  end
end

