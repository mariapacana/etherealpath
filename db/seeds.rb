# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

participants = [
  {first_name: "Maria", last_name: "Pacana", phone_number: "+16502008405", code: "aaa"},
  {first_name: "Ben", last_name: "Juster", code: "bbb"}
  {first_name: "Participant", last_name: "1", code: "ccc"}
  {first_name: "Participant", last_name: "2", code: "ddd"}
  {first_name: "Participant", last_name: "3", code: "eee"}
  {first_name: "Participant", last_name: "4", code: "fff"}
  {first_name: "Participant", last_name: "5", code: "ggg"}
]

participants.each do |p|
  Participant.create(p)
end