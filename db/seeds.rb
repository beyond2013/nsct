# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

{
  "Problem Solving and Analytical Skills" => 20,
  "Computer Networks and Cloud Computing" => 10,
  "Programming (C++/Java/Python)" => 10,
  "Data Structures & Algorithms" => 10,
  "Software Engineering" => 10,
  "Web Development" => 10,
  "AI / Machine Learning and Data Analytics" => 10,
  "Databases" => 10,
  "Operating Systems" => 5,
  "Cyber Security" => 5
}.each_with_index do |(name, weight), i|
  Competency.find_or_create_by!(name: name) { |c| c.weight = weight; c.position = i }
end

admin_email    = ENV.fetch("ADMIN_EMAIL", "imran.cs.uob@gmail.com")
admin_password = ENV["ADMIN_PASSWORD"] || SecureRandom.base58(16)

User.find_or_create_by!(email_address: admin_email) do |u|
  u.name = "Admin"
  u.role = :admin
  u.password = admin_password
  u.password_confirmation = admin_password

  # Only shown when the account is first created
  puts "Admin created: #{admin_email} / #{admin_password}" unless ENV["ADMIN_PASSWORD"]
end
