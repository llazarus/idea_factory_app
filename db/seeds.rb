Review.delete_all
Idea.delete_all
User.delete_all

PASSWORD = "supersecret"

super_user = User.create(
  first_name: "Super",
  last_name: "User",
  email: "email@example.com",
  password: PASSWORD,
  admin: true
)

14.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  u = User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}.#{last_name.downcase}@example.com",
    password: PASSWORD
  )
end
users = User.all
puts "Created #{users.count} users!"

50.times do
  i = Idea.create(
    title: Faker::Lorem.question,
    description: Faker::Lorem.sentences(rand(2..6)).join(" "),
    user: users.sample
  )

  if i.valid?
    rand(0..15).times do
      i.reviews << Review.new(
        body: Faker::Lorem.sentences(rand(1..8)).join(" "),
        user: users.sample
      )
    end
  end
end
reviews = Review.all
puts "Created #{Idea.count} ideas!"
puts "Created #{reviews.count} reviews!"
puts "Admin: '#{super_user.email}' and password '#{PASSWORD}'!"