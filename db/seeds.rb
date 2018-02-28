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
 { user:'adam',
   name:'Adam',
   role:'USER',
   password:"adampw",
   email: 'adam@example.com' },
 { user:'barb',
   name:'Barb',
   role:'USER',
   password:"barbpw",
   email: 'barb@example.com' },
 { user:'chuck',
   name:'Chuck',
   role:'USER',
   password:"chuckpw",
   email: 'chuck@example.com' },
 { user:'don',
   name:'Don',
   role:'USER',
   password:"donpw",
   email: 'don@example.com' },
 { user:'eric',
   name:'Eric',
   role:'USER',
   password:"ericpw",
   email: 'eric@example.com' },
 { user:'fawn',
   name:'Fawn',
   role:'USER',
   password:"fawnpw",
   email: 'fawn@example.com' },
 { user:'gabi',
   name:'Gabi',
   role:'USER',
   password:"gabipw",
   email: 'gabi@example.com' },
])

Relation.create(
  [{ name:"design",description:"The Design" },
   { name:"product", description:"products" },
  ])

Assigned.create(
  [{grantor:"so",grantee:"marek",relation:"design",can_grant:true},
   {grantor:"marek",grantee:"adam",relation:"design",can_grant:true},
   {grantor:"adam",grantee:"barb",relation:"design",can_grant:true},
   {grantor:"marek",grantee:"barb",relation:"design",can_grant:true},
   {grantor:"marek",grantee:"gabi",relation:"design",can_grant:false},
   {grantor:"barb",grantee:"chuck",relation:"design",can_grant:true},
   {grantor:"barb",grantee:"don",relation:"design",can_grant:false},
   {grantor:"don",grantee:"eric",relation:"design",can_grant:true},
   {grantor:"eric",grantee:"fawn",relation:"design",can_grant:false},
   {grantor:"eric",grantee:"gabi",relation:"design",can_grant:false},
  ])

Forbidden.create(
  [{user:"marek",relation:"design"},
  ])

Log.create(
  [{user:"so",relation:"table:design",operation:"grant",object:"user:dexter"},
   {user:"so",relation:"table:design",operation:"forbid",object:"user:marek"},
  ])

