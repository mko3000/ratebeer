FactoryBot.define do
  factory :user do
    username { "Nuuhkija" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
  end

  factory :brewery do
    sequence(:name) { |n| "anonymous#{n}" }
    year { 1900 }
    active { true }
  end

  factory :beer do
    sequence(:name) { |n| "beer#{n}" }
    style { "Lager" }
    brewery # olueeseen liittyvä panimo luodaan brewery-tehtaalla
  end

  factory :rating do
    score { 10 }
    beer # reittaukseen liittyvä olut luodaan beer-tehtaalla
    user # reittaukseen liittyvä user luodaan user-tehtaalla
  end
end
