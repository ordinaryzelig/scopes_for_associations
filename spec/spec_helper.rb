require 'pathname'
require 'awesome_print'

require File.join(Pathname(__FILE__).dirname.expand_path, '../lib/scopes_for_associations')

# require support .rb files.
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f}
