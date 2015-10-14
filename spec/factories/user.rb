FactoryGirl.define do

  factory :user do
    Email 'foo@bar.com'
    Password 'secret1234'
    Password_confirmation 'secret1234'
  end

end
