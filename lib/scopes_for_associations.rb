module ScopesForAssociations

  def scopes_for_associations()
    # scopes for belongs_to associations.
    belongs_to_reflections = reflect_on_all_associations(:belongs_to)
    non_polymorphic_belongs_to_reflections = belongs_to_reflections.reject { |reflection| reflection.options[:polymorphic] }
    non_polymorphic_belongs_to_reflections.each do |reflection|
      name = reflection.name
      scope :"for_#{name}", proc { |obj| where(:"#{name}_id" => obj) }
    end
    # scopes for has_many associations.
    #has_many_reflections = reflect_on_all_associations(:has_many)
    #non_through_has_many_reflections = has_many_reflections.reject { |reflection| reflection.options[:through] }
    #non_through_has_many_reflections.each do |reflection|
      #name = reflection.name
      #scope :"for_#{name}", proc { |obj| joins(name).where(name => {:"#{self.class.table_name.singularize}_id" => obj.id}) }
    #end
    # for scope.
    scope :for, proc { |obj| send("for_#{obj.class.name.underscore}", obj) }
  end

end

ActiveRecord::Base.extend ScopesForAssociations
