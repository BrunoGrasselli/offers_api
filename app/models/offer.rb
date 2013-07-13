class Offer
  include Mongoid::Document

  field :title,            type: String
  field :link,             type: String
  field :required_action,  type: String
  field :description,      type: String
  field :payout,           type: Integer
  field :thumbnail,        type: Hash, default: {}

  validates_presence_of :title, :link, :required_action, :payout

  def teaser
    description.present? ? description : required_action
  end
end
