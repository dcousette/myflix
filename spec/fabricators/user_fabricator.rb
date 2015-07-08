Fabricator(:user) do 
  email_address { Faker::Internet.email}
  full_name {Faker::Name.name}
  password 'password'
end