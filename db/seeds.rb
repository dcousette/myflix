# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title:'Futurama', description:'A funny cartoon show set in the future.', 
            small_cover_url:'/public/tmp/futurama.jpg', large_cover_url:'/public/tmp/futurama.jpg')

Video.create(title:'Family Guy', description:'A cartoon about a baby named Stuey', 
            small_cover_url:'/public/tmp/family_guy.jpg', large_cover_url:'/public/tmp/family_guy.jpg')

Video.create(title:'South Park', description:'A cartoon about some bad little kids.', 
            small_cover_url:'/public/tmp/south_park.jpg', large_cover_url:'/public/tmp/south_park.jpg')


Category.create(name:"TV Comedies")
Category.create(name:"TV Dramas")
Category.create(name:"Reality TV")