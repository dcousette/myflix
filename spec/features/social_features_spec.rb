require 'spec_helper'

feature "Social networking" do
    given(:jane) { Fabricate(:user) }
    given(:joe) { Fabricate(:user) }
    given(:tv_comedies) { Fabricate(:category, name: 'TV Comedies') }

  scenario "following a user" do 
    futurama = Fabricate(:video, title: 'Futurama', category: tv_comedies)
    jane_review = Fabricate(:review, video: futurama, user: jane)
    
    sign_in(joe)
    click_on_video_from_home_page(futurama)
    click_on jane_review.user.full_name
    click_on 'Follow'
    
    expect(page).to have_content jane_review.user.full_name
  end
  
  scenario "unfollowing a user" do 
    friends = Fabricate(:friendship, leader: jane, follower: joe)
    
    sign_in(joe)
    click_on 'People'
    click_on_friendship(friends)
  
    expect(page).to have_no_content(user_path(jane)) 
  end
  
  def click_on_friendship(friendship)
    find("a[href='/friendships/#{friendship.id}']").click
  end

  def click_on_video_from_home_page(video)
    find("a[href='/videos/#{video.id}']").click 
  end
end

