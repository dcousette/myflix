require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
  it { should validate_presence_of(:name) }
  
  describe '#recent_videos' do
    it 'returns the videos in reverse chronical order by created_at' do 
      tv_shows = Category.create(name:'TV Shows')
      
      futurama = Video.create(title:"Futurama", 
                              description:"It's about the Future, duh!",
                              category: tv_shows,
                              created_at: 1.day.ago)
      
      back_to_future = Video.create(title:"Back to the Future", 
                              description:"Michael J Fox!",
                              category: tv_shows)
      
      expect(tv_shows.recent_videos).to eq([back_to_future, futurama])
    end
    
    it 'returns all of the videos if there are less than 6 videos' do 
      tv_shows = Category.create(name:'TV Shows')
      
      futurama = Video.create(title:"Futurama", 
                              description:"It's about the Future, duh!",
                              category: tv_shows)
      
      back_to_future = Video.create(title:"Back to the Future", 
                              description:"Michael J Fox!",
                              category: tv_shows)
      
      expect(tv_shows.recent_videos.count).to eq(2)
    end 
    
    it 'returns 6 videos if there are more than 6 videos' do 
      tv_shows = Category.create(name:'TV Shows')
      
      7.times { Video.create(title:"Test Movie", description:"Justing testing things", 
                             category: tv_shows)}
      
      expect(tv_shows.recent_videos.count).to eq(6)  
    end
    
    it 'returns the most recent 6 videos' do 
      tv_shows = Category.create(name:'TV Shows')
      
      futurama = Video.create(title:"Futurama", 
                              description:"It's about the Future, duh!",
                              category: tv_shows,
                              created_at: 1.day.ago)
      
      7.times { Video.create(title:"Test Movie", description:"Justing testing things", 
                             category: tv_shows)}
      
      expect(tv_shows.recent_videos).not_to include(futurama) 
    end
    
    it "returns an empty array if the category doesn't have any videos" do 
      tv_shows = Category.create(name:'TV Shows')
      
      expect(tv_shows.recent_videos).to eq([])
    end
  end
end
