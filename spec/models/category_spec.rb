require 'spec_helper'

describe Category do
  it 'saves itself' do
    tv_comedies = Category.new(name:'TV Comedies')
    tv_comedies.save 
    Category.first.name = 'TV Comedies'
  end

  it 'has many videos' do 
    # make Category
    tv_comedies = Category.create(name:'TV Comedies')

    # make videos
    # add videos to Category
    spaceballs = Video.create(title:'Spaceballs', 
                 description:'A funny space comedy!', 
                 category: tv_comedies)
    et         = Video.create(title:'E.T.', 
                 description:'An awesome extraterrestrial movie.', 
                 category: tv_comedies)
    goonies    = Video.create(title:'The Goonies', 
                 description:'A funny adventure with some kids!', 
                 category: tv_comedies)  

    #check that category videos is > 1
    #alt syntax
    expect(tv_comedies.videos).to eq([et, spaceballs, goonies])
  end
end
