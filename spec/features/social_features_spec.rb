require 'spec_helper'

feature "Social networking" do
    given(:jane) { Fabricate(:user) }
    given(:joe) { Fabricate(:user) }
    given(:tv_comedies) { Fabricate(:category, name: 'TV Comedies') }

  scenario "following a user" do 
    futurama = Fabricate(:video, title: 'Futurama', category: tv_comedies)
    jane_review = Fabricate(:review, video: futurama, user: jane)
    
    sign_in(joe)
    expect(page).to have_content "Welcome, #{joe.full_name}"

    find("a[href='/videos/#{futurama.id}']").click 
    expect(page).to have_content futurama.description
    
    click_on jane_review.user.full_name
    click_on 'Follow'
    expect(page).to have_content 'People I Follow'
    expect(page).to have_content jane_review.user.full_name
  end
  
  scenario "unfollowing a user" do 
    friends = Fabricate(:friendship, leader: jane, follower: joe)
    sign_in(joe)
    expect(page).to have_content "Welcome, #{joe.full_name}"
    
    click_on 'People'
    expect(page).to have_content 'People I Follow'
    
    find("a[href='/friendships/#{friends.id}']").click
    expect(current_path).to eq(people_path)
  end
end