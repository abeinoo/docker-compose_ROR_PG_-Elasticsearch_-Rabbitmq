FactoryGirl.define do
  factory :bug do
    application_token "MyString"
    number 1
    status 1
    priority 1
    comment "MyText"
    state_id 1
  end
end
