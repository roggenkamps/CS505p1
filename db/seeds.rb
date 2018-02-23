# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
[{ user_id:'so',     name:'Security Officer',role:'SO'},
 { user_id:'marek',  name:'Marek',           role:'USER'},
 { user_id:'dexter', name:'Dexter',          role:'USER'},
])

