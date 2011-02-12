module ScopesForAssociations

  def scopes_for_associations()
    define_scopes_for_non_polymorpic_belongs_to_associations
    define_scopes_for_polymorpic_belongs_to_associations
    define_named_scope_for
  end

  private

  def non_polymorphic_belongs_to_reflections
    reflect_on_all_associations(:belongs_to).reject { |reflection| reflection.options[:polymorphic] }
  end

  def polymorphic_belongs_to_reflections
    reflect_on_all_associations(:belongs_to).select { |reflection| reflection.options[:polymorphic] }
  end

  def define_scopes_for_non_polymorpic_belongs_to_associations
    non_polymorphic_belongs_to_reflections.each do |reflection|
      name = reflection.name
      attribute_name = :"#{name}_id"
      scope_name_for_attribute_id = :"for_#{attribute_name}"
      scope scope_name_for_attribute_id, proc { |id| where(attribute_name => id) }
      scope :"for_#{name}", proc { |obj| send(scope_name_for_attribute_id, obj.id) }
    end
  end

  def define_scopes_for_polymorpic_belongs_to_associations
    polymorphic_belongs_to_reflections.each do |reflection|
      name = reflection.name
      attribute_name_for_polymorphic_type = :"#{name}_type"
      attribute_name_for_polymorphic_id = :"#{name}_id"
      scope_name_for_polymorphic_id = :"for_#{attribute_name_for_polymorphic_id}"
      scope_name_for_polymorphic_type = :"for_#{attribute_name_for_polymorphic_type}"
      scope scope_name_for_polymorphic_id, proc { |id| where(attribute_name_for_polymorphic_id => id) }
      scope scope_name_for_polymorphic_type, proc { |string| where(attribute_name_for_polymorphic_type => string) }
      scope :"for_#{name}", proc { |obj| send(scope_name_for_polymorphic_type, obj.class.name).where(:"#{name}_id" => obj.id) }
    end
  end

  # return [name, reflection] from matching reflection.klass and obj.class
  def reflection_for_object(obj)
    reflections.detect { |name, reflection| reflection.class_name == obj.class.name }
  end

  def define_named_scope_for
    scope :for, proc { |object|
      name, reflection = reflection_for_object(object)
      if name
        send(:"for_#{name}", object)
      else
        # see if it's polymorphic from object's associations.
        reflection = object.class.reflect_on_all_associations(:has_many).detect { |reflection|
          reflection.options[:as] && reflection.klass == self
        }
        if reflection
          send(:"for_#{reflection.options[:as]}", object)
        else
          raise "No scope for #{object.class}. If the associaton is polymorphic, make sure #{object.class} defines something like 'has_many :#{self.name.underscore.pluralize}, :as => :#{self.name.underscore + 'able'}'."
        end
      end
    }
  end

end

ActiveRecord::Base.extend ScopesForAssociations
