Fabricator(:video) do
  title {Faker::Lorem.words(5).join(" ")}
  description {Faker::Lorem.paragraph(2)}
  category
  small_cover "file1"
  large_cover "file2"
end
