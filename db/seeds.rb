require 'faker'
require 'open-uri'
require 'json'

def create_user(login)
  response = `curl -X POST http://localhost:3000/v1/users -d "user[login]=#{login}"`
  JSON.parse(response)
end

def create_post(user_id, title, body, ip)
  response = `curl -X POST http://localhost:3000/v1/posts -d "post[user_id]=#{user_id}&post[title]=#{title}&post[body]=#{body}&post[ip]=#{ip}"`
  JSON.parse(response)
end

def create_rating(post_id, user_id, value)
  response = `curl -X POST http://localhost:3000/v1/ratings -d "rating[post_id]=#{post_id}&rating[user_id]=#{user_id}&rating[value]=#{value}"`
  JSON.parse(response)
end

100.times do |i|
  login = Faker::Internet.unique.username
  create_user(login)
end

ips = []
50.times do |i|
  ips << "192.168.1.#{i+1}"
end

post_created = 0
200_000.times do |i|
  user = User.order('RANDOM()').first
  title = Faker::Lorem.sentence
  body = Faker::Lorem.paragraph
  ip = ips.sample

  post_data = create_post(user.id, title, body, ip)
  post_id = post_data['post']['id']
  post_created += 1

  if post_created <= 160000
    users_that_voted = []
    8.times do
      user_voter = User.order('RANDOM()').first
      next if users_that_voted.include?(user_voter.id)

      value = rand(1..5)
      create_rating(post_id, user_voter.id, value)
      users_that_voted << user_voter.id
    end
  end
end

puts "Created 100 users, 200k posts."
