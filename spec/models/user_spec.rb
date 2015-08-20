describe User do 
  it { should validate_presence_of(:email_address) }  
  it { should validate_presence_of(:password) }  
  it { should validate_presence_of(:full_name) }  
  it { should validate_uniqueness_of(:email_address) }  
  it { should have_many(:queue_items).order('position ASC') }
 
  describe "#queued_video?" do 
    it "returns true if the current user has queued the video" do 
      video = Fabricate(:video)
      user = Fabricate(:user)
      item1 = Fabricate(:queue_item, video: video, user: user)
      user.queued_video?(video).should be_truthy
    end
    
    it "returns false if the current user hasn't queued the video" do 
      video = Fabricate(:video)
      user = Fabricate(:user)
      user.queued_video?(video).should be_falsey
    end
  end
end 