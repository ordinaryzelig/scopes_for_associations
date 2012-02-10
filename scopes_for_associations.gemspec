# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'scopes_for_associations/version'

Gem::Specification.new do |s|
  s.name        = 'scopes_for_associations'
  s.version     = ScopesForAssociations::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Jared Ning']
  s.email       = ['jared@redningja.com']
  s.homepage    = 'https://github.com/ordinaryzelig/scopes_for_associations'
  s.summary     = %q{Define very basic, commonly used scopes for ActiveRecord associations}
  s.description = %q{Define very basic, commonly used scopes for ActiveRecord associations. E.g. if a Post model has an author and a category association, scopes will be defined like Post.for(author) or Post.for(category).}

  s.rubyforge_project = 'scopes-for-associations'

  s.files         = `git ls-files`.split($/)
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split($/)
  s.executables   = `git ls-files -- bin/*`.split($/).map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activerecord', '>= 3.0.0'

  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'rspec', '2.5.0'
  s.add_development_dependency 'sqlite3', '1.3.5'
end
