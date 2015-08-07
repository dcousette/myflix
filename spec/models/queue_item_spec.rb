require 'spec_helper'

describe QueueItem do 
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }
  
  describe '#video_title' do 
    it 'returns the title for the associated video' do 
      video = Fabricate(:video, title:'Futurama')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq('Futurama')
    end
  end
  
  describe '#rating' do
    it 'returns the rating for the review when the review is present' do
      video = Fabricate(:video)
      user1 = Fabricate(:user)
      review = Fabricate(:review, user: user1, video: video, rating: 5)
      queue_item = Fabricate(:queue_item, video: video, user: user1)
      expect(queue_item.rating).to eq(5)
    end
    
    it 'returns nil when the review is not present' do 
      video = Fabricate(:video)
      user1 = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user1)
      expect(queue_item.rating).to eq(nil)
    end
  end
  
  describe '#category_name' do 
    it "returns the name of the category for the queue item's video" do 
      comedy = Fabricate(:category, name:"TV Comedies")
      video = Fabricate(:video, category: comedy)
      user1 = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user1)
      expect(queue_item.category_name).to eq("TV Comedies")
    end
  end
  
  describe '#category' do 
    it 'returns the category of the video' do 
      comedy = Fabricate(:category, name:"TV Comedies")
      video = Fabricate(:video, category: comedy)
      user1 = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user1)
      expect(queue_item.category).to eq(comedy)
    end
  end
end