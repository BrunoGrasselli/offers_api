require 'spec_helper'

describe Application do
  it "validates presence of external_id" do
    app = Application.new(external_id: nil)
    app.valid?
    app.errors[:external_id].should_not be_empty
  end

  it "validates presence of api_key" do
    app = Application.new(api_key: nil)
    app.valid?
    app.errors[:api_key].should_not be_empty
  end
end

