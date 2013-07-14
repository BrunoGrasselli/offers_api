require 'spec_helper'

describe OffersPresenter do
  let!(:offer_1) { Offer.create!({
    title: 'My first offer',
    link: 'http://link.com/offer1',
    payout: 10,
    required_action: 'action 1',
    thumbnail: {
      lowres: 'http://link1.example.com/lowres.png',
      hires: 'http://link1.example.com/hires.png'
    },
    offer_types: [OfferType.new(external_id: 100)]
  }) }

  let!(:offer_2) { Offer.create!({
    title: 'My second offer',
    link: 'http://link.com/offer2',
    payout: 20,
    required_action: 'action 2',
    description: 'some description',
    thumbnail: {
      lowres: 'http://link2.example.com/lowres.png',
      hires: 'http://link2.example.com/hires.png'
    },
    offer_types: [OfferType.new(external_id: 101)]
  }) }

  let(:presenter) { described_class.new Offer.all }

  describe "#to_hash" do
    it "has the quantity of offers" do
      presenter.to_hash[:count].should eq 2
    end

    it "has the quantity of pages" do
      presenter.to_hash[:pages].should eq 1
    end

    context "offers" do
      let(:offers) { presenter.to_hash[:offers] }

      it "has 2 offers" do
        offers.should have(2).offers
      end

      it "has links" do
        offers[0][:link].should eq 'http://link.com/offer1'
        offers[1][:link].should eq 'http://link.com/offer2'
      end

      it "has teaser" do
        offers[0][:teaser].should eq 'action 1'
        offers[1][:teaser].should eq 'some description'
      end

      it "has required_action" do
        offers[0][:required_action].should eq 'action 1'
        offers[1][:required_action].should eq 'action 2'
      end

      it "has title" do
        offers[0][:title].should eq 'My first offer'
        offers[1][:title].should eq 'My second offer'
      end

      it "has payout" do
        offers[0][:payout].should eq 10
        offers[1][:payout].should eq 20
      end

      it "has low resolution thumbnail" do
        offers[0][:thumbnail][:lowres].should eq 'http://link1.example.com/lowres.png'
        offers[1][:thumbnail][:lowres].should eq 'http://link2.example.com/lowres.png'
      end

      it "has high resolution thumbnail" do
        offers[0][:thumbnail][:hires].should eq 'http://link1.example.com/hires.png'
        offers[1][:thumbnail][:hires].should eq 'http://link2.example.com/hires.png'
      end

      it "has offer types" do
        offers[0][:offer_types][0][:offer_type_id].should eq 100
        offers[1][:offer_types][0][:offer_type_id].should eq 101

        offers[0][:offer_types][0][:readable].should eq 'Mobile'
        offers[1][:offer_types][0][:readable].should eq 'Download'
      end
    end
  end

  describe "#to_json" do
    before do
      presenter.stub(:to_hash).and_return({offers: [{title: 'test'}]})
    end

    it "returns a json with the same content of the to_hash" do
      presenter.to_json.should eq '{"offers":[{"title":"test"}]}'
    end
  end

  describe "#to_xml" do
    before do
      presenter.stub(:to_hash).and_return({offers: [{title: 'test'}]})
    end

    it "returns an xml with the same content of the to_hash" do
      presenter.to_xml.should eq %{<?xml version="1.0" encoding="UTF-8"?>
<response>
  <offers type="array">
    <offer>
      <title>test</title>
    </offer>
  </offers>
</response>
}
    end
  end
end

