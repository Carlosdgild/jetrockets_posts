# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    user
    post
    value { rand(1..5) }
  end
end
