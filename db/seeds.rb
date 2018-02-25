# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:o
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
[{ user:'so',     
   name:'Security Officer',
   role:'SO',   
   password:"password",
   email:'so@example.com'
 },
 { user:'marek',  
   name:'Marek',
   role:'USER',
   password:"marekpw",
   email: 'marek@example.com' },
 { user:'dexter',
   name:'Dexter',
   role:'USER',
   password:"dexterpw",
   email: 'dexter@example.com' },
])

Relation.create(
  [{ name:"design",description:"The Design" },
   { name:"product", description:"products" },
  ])

Assigned.create(
  [{grantor:"so",grantee:"dexter",relation:"design",can_grant:true}
  ])

Forbidden.create(
  [{user:"marek",relation:"design"},
  ])

Log.create(
  [{user:"so",relation:"design",operation:"forbid",object:"user:marek"},
  ])

