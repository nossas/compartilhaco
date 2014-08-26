# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Campaign.create(
  ends_at: 10.days.from_now,
  share_link: "http://minhascidades.org.br",
  goal: 5,
  organization: Organization.first,
  title: "Salvem as baleias",
  image: File.new("#{Rails.root}/spec/support/images/whale.jpg"),
  description: Faker::Lorem.paragraphs(3).join("\n\n"),
  user: User.first
)
