# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    user
    title { 'Sample Title' }
    body { 'Sample body text for the post.' }
    ip { "192.#{rand(999)}.1.#{rand(99)}" }
  end
end
