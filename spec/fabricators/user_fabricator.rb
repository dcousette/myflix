Fabricator(:user) do
  email_address { Faker::Internet.email}
  full_name {Faker::Name.name}
  password 'fake_password'
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end
