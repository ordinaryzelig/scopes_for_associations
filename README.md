# Scopes for Associations [![Build Status](https://secure.travis-ci.org/ordinaryzelig/scopes_for_associations.png?branch=master)](http://travis-ci.org/ordinaryzelig/scopes_for_associations)

https://github.com/ordinaryzelig/scopes_for_associations

## Description

Define very basic, commonly used scopes for ActiveRecord associations.

## Description through code

```ruby
class Movie < ActiveRecord::Base
  belongs_to :director
  scopes_for_associations
end

Movie.for_director_id(Director.first.id)
#=> [#<Movie ..., director_id: 1>]
Movie.for_director(Director.first)
#=> [#<Movie ..., director_id: 1>]
Movie.for(Director.first)
#=> [#<Movie ..., director_id: 1>]
```

## Supported association types

* belongs_to (non-polymorpic and polymorphic)

If you're like me and prefer learning through looking at code,
read through the specs.
The examples here are basically reproductions of the tests.

### belongs_to (non-polymorphic)

```ruby
class Movie < ActiveRecord::Base
  belongs_to :director
  scopes_for_associations
end

Movie.for_director_id(Director.first.id)
#=> [#<Movie ..., director_id: 1>]
Movie.for_director(Director.first)
#=> [#<Movie ..., director_id: 1>]
Movie.for(Director.first)
#=> [#<Movie ..., director_id: 1>]
```

### belongs_to (polymorphic)

```ruby
class Movie < ActiveRecord::base
  # It is important to define this association.
  has_many :comments, :as => :commentable
end
class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
end

Comment.for_commentable_id(Movie.first.id)
#=> [#<Comment ..., commentable_type: "Movie", commentable_id: 1>]
Comment.for_commentable_type('Movie')
#=> [#<Comment ..., commentable_type: "Movie", commentable_id: 1>, ...]
Comment.for_commentable(movie)
#=> [#<Comment ..., commentable_type: "Movie", commentable_id: 1>]
Comment.for(Movie.first)
#=> [#<Comment ..., commentable_type: "Movie", commentable_id: 1>]
```

## Compatibility

Tested with ActiveRecord >=3.0.0
