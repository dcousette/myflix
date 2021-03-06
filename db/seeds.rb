# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tv_comedies = Category.create(name:"TV Comedies")
tv_dramas   = Category.create(name:"TV Dramas")
reality_tv  = Category.create(name:"Reality TV")

futurama = Video.create(title:'Futurama', 
             description:'A funny cartoon show set in the future.', 
             small_cover_url:'futurama.jpg', 
             large_cover_url:'monk_large.jpg',
             category: tv_dramas)

family_guy = Video.create(title:'Family Guy', 
             description:'A cartoon about a baby named Stuey', 
             small_cover_url:'family_guy.jpg', 
             large_cover_url:'monk_large.jpg',
             category: tv_comedies)

south_park = Video.create(title:'South Park', 
             description:'A cartoon about some bad little kids.', 
             small_cover_url:'south_park.jpg', 
             large_cover_url:'monk_large.jpg',
             category: reality_tv)

Video.create(title:'Family Guy', 
             description:'A cartoon about a baby named Stuey', 
             small_cover_url:'family_guy.jpg', 
             large_cover_url:'monk_large.jpg',
             category: tv_comedies)
   
Video.create(title:'Family Guy', 
             description:'A cartoon about a baby named Stuey', 
             small_cover_url:'family_guy.jpg', 
             large_cover_url:'monk_large.jpg',
             category: tv_comedies)
             
Video.create(title:'Family Guy', 
             description:'A cartoon about a baby named Stuey', 
             small_cover_url:'family_guy.jpg', 
             large_cover_url:'monk_large.jpg',
             category: tv_comedies)

Video.create(title:'Family Guy', 
             description:'A cartoon about a baby named Stuey', 
             small_cover_url:'family_guy.jpg', 
             large_cover_url:'monk_large.jpg',
             category: tv_comedies)   
Video.create(title:'Family Guy', 
             description:'A cartoon about a baby named Stuey', 
             small_cover_url:'family_guy.jpg', 
             large_cover_url:'monk_large.jpg',
             category: tv_comedies)
             
Video.create(title:'Family Guy', 
             description:'A cartoon about a baby named Stuey', 
             small_cover_url:'family_guy.jpg', 
             large_cover_url:'monk_large.jpg',
             category: tv_comedies)
             
deshawn = User.create(email_address: 'dcousette@gmail.com', password: 'dcousette', full_name: 'DeShawn Cousette')
niven = User.create(email_address: 'niven@gmail.com', password: 'niven', full_name: 'Niven Cousette')

Review.create(user: deshawn, video: futurama, rating: 5, content:'This movie is so awesome. I really liked it!')
Review.create(user: deshawn, video: futurama, rating: 1, content:'This movie is so bad. I really hated it!')
Review.create(user: niven, video: south_park, rating: 5, content:'This makes me laugh so hard!')