FactoryGirl.define do
  factory :offer do
    title           'My offer'
    link            'http://testlink.com/my_link'
    required_action 'action'
  end
end
