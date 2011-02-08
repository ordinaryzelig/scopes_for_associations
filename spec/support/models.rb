class Movie < ActiveRecord::Base

  belongs_to :director
  belongs_to :production_company
  has_one :trailer

  scopes_for_associations

end

class Director < ActiveRecord::Base
end

class ProductionCompany < ActiveRecord::Base
end

class Trailer < ActiveRecord::Base
  belongs_to :movie
  belongs_to :director
  belongs_to :production_company
  scopes_for_associations
end
