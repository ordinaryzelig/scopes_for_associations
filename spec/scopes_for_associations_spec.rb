require 'spec_helper'

describe ScopesForAssociations do

  let(:director) { Director.create! }
  let(:production_company) { ProductionCompany.create! }

  it 'should be included in ActiveRecord::Base' do
    ActiveRecord::Base.should respond_to('scopes_for_associations')
  end

  it 'should define for_x scopes' do
    Movie.should respond_to('for_director')
    Movie.should respond_to('for_production_company')
  end

  it 'should scope for association as object' do
    Movie.for_director(director).to_sql.should eq(Movie.where(:director_id => director.id).to_sql)
    Movie.for_production_company(production_company).to_sql.should eq(Movie.where(:production_company_id => production_company.id).to_sql)
  end

  it 'should have a "polymorphic" scope :for' do
    Movie.for(director).to_sql.should eq(Movie.for_director(director).to_sql)
    Movie.for(production_company).to_sql.should eq(Movie.for_production_company(production_company).to_sql)
  end

end
