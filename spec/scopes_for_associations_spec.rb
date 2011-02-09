require 'spec_helper'

describe ScopesForAssociations do

  let(:director) { Director.create! }
  let(:production_company) { ProductionCompany.create! }
  let(:movie) { Movie.create!(:director => director, :production_company => production_company) }
  let(:comment) { Comment.create! :commentable_type => 'Movie', :commentable_id => movie.id }

  it 'should be included in ActiveRecord::Base' do
    ActiveRecord::Base.should respond_to('scopes_for_associations')
  end

  context 'for non-polymorphic belongs_to associations' do

    it 'should define for_x scopes' do
      Movie.should respond_to('for_director')
      Movie.should respond_to('for_production_company')
    end

    it 'should scope for association as object' do
      Movie.for_director(director).to_sql.should eq(Movie.where(:director_id => director.id).to_sql)
      Movie.for_director(director).should eq([movie])
      Movie.for_production_company(production_company).to_sql.should eq(Movie.where(:production_company_id => production_company.id).to_sql)
      Movie.for_production_company(director).should eq([movie])
    end

    it 'should have a "polymorphic" scope :for' do
      Movie.for(director).to_sql.should eq(Movie.for_director(director).to_sql)
      Movie.for(director).should eq([movie])
      Movie.for(production_company).to_sql.should eq(Movie.for_production_company(production_company).to_sql)
      Movie.for(production_company).should eq([movie])
    end

  end

  context 'for polymorphic belongs_to associations' do

    it 'should define for_x scopes' do
      Comment.should respond_to('for_commentable')
    end

    it 'should scope for association as object' do
      Comment.for_commentable(movie)
    end

    it 'should scope for association as object' do
      Comment.for_commentable(movie).to_sql.should eq(Comment.where(:commentable_type => 'Movie', :commentable_id => movie.id).to_sql)
      Comment.for_commentable(movie).should eq([comment])
    end

    it 'should have a "polymorphic" scope :for' do
      Comment.for(movie).to_sql.should eq(Comment.for_commentable(movie).to_sql)
    end

  end

end
