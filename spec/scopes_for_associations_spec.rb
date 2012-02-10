require 'spec_helper'

describe ScopesForAssociations do

  let(:director) { Director.create! }
  let(:production_company) { ProductionCompany.create! }
  let(:movie) { Movie.create!(:director => director, :production_company => production_company) }

  it 'should be included in ActiveRecord::Base' do
    ActiveRecord::Base.should respond_to(:scopes_for_associations)
  end

  context 'for non-polymorphic belongs_to associations' do

    it 'should define useful scopes' do
      Movie.should define_scopes(
        :for_director_id,
        :for_director,
        :for_production_company_id,
        :for_production_company,
        :for
      )
    end

    it 'should scope for association id' do
      Movie.for_director_id(director.id).should query_the_same_as(Movie.where(:director_id => director.id))
      Movie.for_production_company_id(production_company.id).should query_the_same_as(Movie.where(:production_company_id => production_company.id))
    end

    it 'should scope for association as object' do
      Movie.for_director(director).should query_the_same_as(Movie.for_director_id(director.id))
      Movie.for_production_company(production_company).should query_the_same_as(Movie.for_production_company_id(production_company.id))
    end

    it 'should have an all encompassing scope :for' do
      Movie.for(director).should query_the_same_as(Movie.for_director(director))
      Movie.for(production_company).should query_the_same_as(Movie.for_production_company(production_company))
    end

    it 'should return correct results' do
      Movie.for(director).should eq([movie])
      Movie.for(production_company).should eq([movie])
    end

  end

  context 'for polymorphic belongs_to associations' do

    let(:trailer) { Trailer.create!(:movie => movie) }
    let(:movie_comment) { Comment.create! :commentable_type => 'Movie', :commentable_id => movie.id }
    let(:trailer_comment) { Comment.create! :commentable_type => 'Trailer', :commentable_id => trailer.id }

    it 'should define uesful scopes' do
      Comment.should define_scopes(
        :for_commentable_id,
        :for_commentable_type,
        :for_commentable,
        :for
      )
    end

    it 'should scope for polymorphic id' do
      Comment.for_commentable_type('Movie').should query_the_same_as(Comment.where(:commentable_type => 'Movie'))
    end

    it 'should scope for polymorphic type' do
      Comment.for_commentable_id(movie.id).should query_the_same_as(Comment.where(:commentable_id => movie.id))
    end

    it 'should scope for association as object' do
      # The order of the expected where statements is necessary for some reason.
      # This came up when I used bundle exec rake, but did not fail when I used rake alone. Go figure.
      Comment.for_commentable(movie).should   query_the_same_as(Comment.where(:commentable_type => 'Movie').where(:commentable_id => movie.id))
      Comment.for_commentable(trailer).should query_the_same_as(Comment.where(:commentable_type => 'Trailer').where(:commentable_id => trailer.id))
    end

    it 'should have an all encompassing scope :for' do
      Comment.for(movie).should query_the_same_as(Comment.for_commentable(movie))
      Comment.for(trailer).should query_the_same_as(Comment.for_commentable(trailer))
    end

    it 'should return correct results' do
      Comment.for(movie).should eq([movie_comment])
      Comment.for(trailer).should eq([trailer_comment])
    end

  end

end
