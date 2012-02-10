require 'sqlite3'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define do
  create_table :movies, :force => true do |t|
    t.belongs_to :director
    t.belongs_to :production_company
  end
  create_table(:directors, :force => true)# { |t| }
  create_table(:production_companies, :force => true) { |t| }
  create_table :trailers, :force => true do |t|
    t.belongs_to :movie
  end
  create_table :comments, :force => true do |t|
    t.belongs_to :commentable, :polymorphic => true
  end
end
