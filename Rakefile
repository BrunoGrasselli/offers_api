require "./config/boot"

namespace :db do
  desc "Seeds database"
  task :seed do
    puts "Creating application"
    Application.create! external_id: "157", api_key: "b07a12df7d52e6c118e5d47d3f9e60135b109a1f"

    puts "Creating offers"

    12.times do |i|
      Offer.create! offer_types: [OfferType.new(external_id: 112)], title: "My Title #{i+1}", link: "http://google.com", required_action: "Action", description: "Description", payout: rand(20) * 100, thumbnail: {"lowres"=>"http://s3.amazonaws.com/getnow/icon/games/arcade/app-angry-birds-space-icon.png"}
    end
  end
end
