class OffersPresenter
  def initialize(offers)
    @offers = offers
  end

  def to_hash
    {
      offers: offers_list
    }
  end

  def to_xml
    to_hash.to_xml(root: 'response')
  end

  private

  def offers_list
    offers.map do |offer|
      {
        link: offer.link,
        teaser: offer.teaser,
        required_action: offer.required_action,
        title: offer.title
      }
    end
  end

  def offers
    @offers
  end
end
