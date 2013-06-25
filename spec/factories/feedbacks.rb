# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    text { Faker::Lorem.paragraph( rand(7)+1 ) }
    subject { Faker::Lorem.sentence }
    from { Faker::Internet.email }
    to { Faker::Internet.email }
    type {[:report_article, :get_help ,:send_feedback].sample}
  end
end
