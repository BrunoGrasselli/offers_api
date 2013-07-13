class Application
  include Mongoid::Document

  field :external_id, type: String
  field :api_key,     type: String

  validates_presence_of :external_id, :api_key
end
