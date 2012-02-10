RSpec::Matchers.define :define_scopes do |*scopes|
  match do |model_class|
    scopes.each do |scope|
      model_class.respond_to? scope
    end
  end
end

RSpec::Matchers.define :query_the_same_as do |expected_relation|
  match do |example_relation|
    example_relation.to_sql.should eq(expected_relation.to_sql)
  end
end
