class OfferType
  include Mongoid::Document

  READABLE_MAP = {
    100 => 'Mobile',
    101 => 'Download',
    102 => 'Trial',
    103 => 'Sale',
    104 => 'Registration',
    105 => 'Registration',
    106 => 'Games',
    107 => 'Games',
    108 => 'Registration',
    109 => 'Games',
    110 => 'Surveys',
    111 => 'Registration',
    112 => 'Free',
    113 => 'Video'
  }

  field :external_id, type: Integer

  embedded_in :offer

  validates_presence_of :external_id

  def readable
    READABLE_MAP[external_id]
  end
end
