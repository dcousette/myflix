require 'spec_helper'

describe Video do 
  it 'saves itself' do
    spaceballs = Video.new(title:'Spaceballs', 
                 description:'A funny space comedy!', 
                 category_id:'1') 

    spaceballs.save 
    Video.first.title.should == 'Spaceballs'
  end

  it "belongs to category" do 
    #create category 
    tv_comedies = Category.create(name:'TV Comedies')

    #create video 
    spaceballs = Video.create(title:'Spaceballs', 
                 description:'A funny space comedy!', 
                 category: tv_comedies)

    #test if video has category
    expect(spaceballs.category).to eq(tv_comedies)
  end
end