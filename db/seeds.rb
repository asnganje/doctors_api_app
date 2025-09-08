# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Doctor.create!(
  [
    {
      name: "Dr. Saumu Omar",
      specialization: "Crdiologist",
      biography: "Has over 15 years of experience in treating heart-related conditions...",
      picture: "https://example.com/images/dr-alice.jpg"
    },
    {
      name: "Dr. John Mwangi",
      specialization: "Dermatologist",
      biography: "Dr. John Mwangi specializes in skin care and dermatological surgery...",
      picture: "https://example.com/images/dr-john.jpg"
    },
    {
      name: "Dr. Jane Otieno",
      specialization: "Neurologist",
      biography: "Dr. Jane Otieno is an expert in treating brain and nervous system conditions.",
      picture: "https://example.com/images/dr-jane.jpg"
    }
]
)