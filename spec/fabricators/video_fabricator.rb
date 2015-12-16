Fabricator(:video) do
  title {Faker::Lorem.words(5).join(" ")}
  description {Faker::Lorem.paragraph(2)}
  category
  small_cover_url "file1"
  large_cover_url "file2"
end
