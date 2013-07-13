require 'spec_helper'

describe OffersPresenter do
  let!(:offer_1) { Offer.create!({
    title: 'My first offer',
    link: 'http://link.com/offer1',
    required_action: 'action 1'
  }) }

  let!(:offer_2) { Offer.create!({
    title: 'My second offer',
    link: 'http://link.com/offer2',
    required_action: 'action 2',
    description: 'some description'
  }) }

  let(:presenter) { described_class.new Offer.all }

  describe "#to_hash" do
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
    end
  end
end

