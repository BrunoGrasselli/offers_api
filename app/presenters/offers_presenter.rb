class OffersPresenter
  def initialize(offers)
    @offers = offers
  end

  def to_hash
    {
      count: offers.size,
      pages: pages,
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
        title: offer.title,
        payout: offer.payout,
        thumbnail: {
          lowres: offer.thumbnail['lowres'],
          hires: offer.thumbnail['hires']
        },
        offer_types: offer_types(offer)
      }
    end
  end

  def offer_types(offer)
    offer.offer_types.map do |type|
      {
        offer_type_id: type.external_id,
        readable: type.readable
      }
    end
  end

  def offers
    @offers
  end

  def pages
    (offers.size.to_f / Offer.per_page).ceil
  end
end
