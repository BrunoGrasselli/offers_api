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

  it "validates presence of required_action" do
    offer.required_action = nil
    offer.valid?
    offer.errors[:required_action].should_not be_empty
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
end

