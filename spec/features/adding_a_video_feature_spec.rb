require 'spec_helper'

feature 'Admin adds a video' do
  given(:admin_user) { Fabricate(:admin) }
  before { Fabricate(:category, name: 'TV Comedies') }

  scenario 'adding a video with valid admin credentials' do
    sign_in(admin_user)
    visit new_admin_video_path
    fill_in 'Title', with: 'New Feature Test'

    select 'TV Comedies', from: 'Category'

    fill_in 'Description', with: 'An awesome video about feature tests! Watch it!'
    fill_in 'Video URL', with: 'https://www.youtube.com/watch?v=AQ-Vf157Ju'
    attach_file 'Large cover', 'spec/support/uploads/monk_large.jpg'
    attach_file 'Small cover', 'spec/support/uploads/monk.jpg'
    click_on 'Add Video'
    expect(page).to have_content('Your video New Feature Test has been added')
    sign_out

    sign_in
    visit video_path(Video.first)
    expect(page).to have_selector "img[src='/uploads/monk_large.jpg']"
    expect(page).to have_selector "a[href='https://www.youtube.com/watch?v=AQ-Vf157Ju']"
  end

  scenario 'adding a video with invalid admin credentials' do
    sign_in
    visit new_admin_video_path
    expect(page).to have_content 'Access denied!'
  end
end
