require 'spec_helper'

describe Video do 
  it 'saves itself' do
    spaceballs = Video.new(title:'Spaceballs', 
                 description:'A funny space comedy!', 
                 category_id:'1') 

    spaceballs.save 
    Video.first.title.should == 'Spaceballs'
  end
end