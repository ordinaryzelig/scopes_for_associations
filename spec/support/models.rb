class Movie < ActiveRecord::Base
  belongs_to :director
  belongs_to :production_company
  has_one :trailer
  has_many :comments, :as => 'commentable'
  scopes_for_associations
end

class Director < ActiveRecord::Base
end

class ProductionCompany < ActiveRecord::Base
end

class Trailer < ActiveRecord::Base
  belongs_to :movie
  has_many :comments, :as => :commentable
  scopes_for_associations
end

class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  scopes_for_associations
end
