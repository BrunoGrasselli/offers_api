class Offer
  include Mongoid::Document

  field :title,            type: String
  field :link,             type: String
  field :required_action,  type: String
  field :description,      type: String
  field :payout,           type: Integer
  field :thumbnail,        type: Hash, default: {}

  embeds_many :offer_types

  validates_presence_of :title, :link, :required_action, :payout

  def self.by_types(types)
    types = types.to_s.split(',').map(&:to_i)

    if types.any?
      all.in('offer_types.external_id' => types)
    else
      all
    end
  end

  def teaser
    description.present? ? description : required_action
  end
end
