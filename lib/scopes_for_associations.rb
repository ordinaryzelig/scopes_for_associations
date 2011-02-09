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
      scope :"for_#{name}", proc { |obj| where(:"#{name}_id" => obj.id) }
    end
  end

  def define_scopes_for_polymorpic_belongs_to_associations
    polymorphic_belongs_to_reflections.each do |reflection|
      name = reflection.name
      scope :"for_#{name}", proc { |obj| where(:"#{name}_type" => obj.class.name, :"#{name}_id" => obj.id) }
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
          raise "no scope for #{object.class}"
        end
      end
    }
  end

end

ActiveRecord::Base.extend ScopesForAssociations
