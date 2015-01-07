# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

participants = [
  {first_name: "Maria", last_name: "Pacana", phone_number: "+16502008405", code: "aaa"},
  # {first_name: "Ben", last_name: "Juster", phone_number: "+14155173133", code: "bbb"}
]

participants.each do |p|
  Participant.create(p)
end